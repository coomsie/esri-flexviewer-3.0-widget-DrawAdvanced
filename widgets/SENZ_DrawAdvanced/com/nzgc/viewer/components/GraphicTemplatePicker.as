package widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components
{
	import com.esri.ags.components.supportClasses.Template;
	import com.esri.ags.events.TemplatePickerEvent;
	import com.esri.viewer.AppEvent;
	
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses.GraphicTemplate;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.components.supportClasses.GraphicTemplateGroup;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.skins.GraphicTemplatePickerSkin;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events.GraphicTemplateEvent;
	import widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events.GraphicTemplatePickerEvent;
	
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Event(name="selectedTemplateChange", type="widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events.GraphicTemplateEvent")]
	[Event(name="templateListChange", type="widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events.GraphicTemplatePickerEvent")]
	[Event(name="organiseModeChange", type="widgets.SENZ_DrawAdvanced.com.nzgc.viewer.events.GraphicTemplatePickerEvent")]
	
	[DefaultProperty("selectedTemplate")]
	[SkinStates("disabled", "loading", "normal")]

	
	public class GraphicTemplatePicker extends SkinnableComponent
	{
		/* -------------------------------------------------------------------
		Component constructor
		---------------------------------------------------------------------- */

		public function GraphicTemplatePicker(templates:Array = null)
		{
			super();
			
			if (templates)
			{
				this.graphicTemplates = templates;
				updateTemplateGroups();
			}
			
			// Add event listener for removing templates
			this.addEventListener(GraphicTemplatePickerEvent.GRAPHIC_TEMPLATE_PICKER_REMOVETEMPLATE,dropTemplate);

			// Add event listener for modifying templates
			this.addEventListener(GraphicTemplatePickerEvent.GRAPHIC_TEMPLATE_PICKER_MODIFYTEMPLATE,modifyTemplate);
		}
		
		
		
		/* -------------------------------------------------------------------
		Component variables
		---------------------------------------------------------------------- */
		
		private var _templates:Array = [];
		private var _selectedTemplate:GraphicTemplate;
		private var _templateGroups:Array = [];
		private var _organisemode:Boolean = false;
		
		
		
		/* -------------------------------------------------------------------
		Component properties
		---------------------------------------------------------------------- */

		[Bindable]
		public function get graphicTemplates():Array
		{
			if (!_templates)
				_templates = [];
			return _templates;			
		}
		
		public function set graphicTemplates(value:Array):void
		{
			if (value)
			{
				_templates = value;
			}
			else 
			{
				_templates = [];				
			}

			// Reset the template groups array
			_templateGroups = [];

			
			if (value && value.length > 0)
			{
				_selectedTemplate = value[0] as GraphicTemplate;				
			} 
			else
			{
				_selectedTemplate = null;
			}
			
			refreshTemplates();
		}

		[Bindable("selectedTemplateChange")]
		public function get selectedTemplate():GraphicTemplate
		{
			return _selectedTemplate;	
		}
		
		public function set selectedTemplate(value:GraphicTemplate):void
		{
			// Check to make sure value is part of the templates array
			if (_templates.length > 0 && _templates.indexOf(value) > -1)
			{
				_selectedTemplate = value;
			}
			else
			{
				_selectedTemplate = null;
			}
			dispatchEvent(new GraphicTemplateEvent(GraphicTemplateEvent.SELECTED_TEMPLATE_CHANGE,this.selectedTemplate));
		}
		
		[Bindable("organiseModeChange")]
		public function get organiseMode():Boolean
		{
			return _organisemode;
			
		}
		
		public function set organiseMode(value:Boolean):void
		{
			if (value)
			{
				_organisemode = value;
				_selectedTemplate = null;
			}
			else
			{
				_organisemode = false;
			}
			dispatchEvent(new GraphicTemplatePickerEvent(GraphicTemplatePickerEvent.GRAPHIC_TEMPLATE_PICKER_ORGANISEMODECHANGE,this));
		}
		
		/**
		 * Returns the lists
		 */
		public function get templateGroups():Array
		{
			return _templateGroups;
		}

		
		
		/* -------------------------------------------------------------------
		Component actions
		---------------------------------------------------------------------- */

		/**
		 * 
		 */
		public function refreshTemplates():void
		{
			// Dispatch event refresh the selected template 
			dispatchEvent(new GraphicTemplateEvent(GraphicTemplateEvent.SELECTED_TEMPLATE_CHANGE,this.selectedTemplate));

			// Dispatch event to refresh the template list 
			dispatchEvent(new GraphicTemplatePickerEvent("templateListChange",this));
			
			// Update the template groups
			updateTemplateGroups();
			
			validateNow();
		}
		
		/**
		 * Updates the groups associated with the templates.
		 */
		private function updateTemplateGroups():void
		{
			var grp:GraphicTemplateGroup
			var template:GraphicTemplate;
			
			// Create a dictionary of the existing groups
			var dic:Dictionary = new Dictionary();
			for each (grp in _templateGroups)
			{
				if (dic[grp.name] == null)
				{
					// Add the group to the dictionary
					dic[grp.name] = grp;
				}
			}
			
			// Iterate through each template and check that a group exists, and that the template is in the group
			for each (template in _templates)
			{
				var groupname:String = template.groupname;
				if (dic[groupname] == null)
				{
					var newGroup:GraphicTemplateGroup = new GraphicTemplateGroup();
					newGroup.name = groupname;
					newGroup.addTemplate(template);
					dic[groupname] = newGroup;
				}
				else
				{
					// Check if the template is already part of the template
					var existingGrp:GraphicTemplateGroup = dic[groupname] as GraphicTemplateGroup;
					if (!existingGrp.contains(template))
					{
						existingGrp.addTemplate(template);
					}
				}
			}

			// Convert dictionary back to array
			_templateGroups = []
			for each (grp in dic)
			{
				_templateGroups.push(grp);	
			}
			
			
			// Remove any disgarded templates
			for each (grp in _templateGroups)
			{
				for each (template in grp.templates)
				{
					if (_templates.indexOf(template) == -1)
					{
						// Remove the template
						grp.removeTemplate(template);
					}
				}
			}
		}

		/**
		 * Called when the user clicks on the remove template icon
		 */
		private function dropTemplate(event:AppEvent):void
		{
			var data:Object = event.data;
			if (data)
			{
				var i:int = _templates.indexOf(data);
				if (i > -1)
				{
					var newArray:Array = [];
					for (var j:int = 0; j < _templates.length; j++)
					{
						if (j != i)
						{
							newArray.push(_templates[j]);
						}
					}
					this.graphicTemplates = newArray;
					updateTemplateGroups();

					// Dispatch event to refresh the template list 
					dispatchEvent(new GraphicTemplatePickerEvent("templateListChange",this));
					this.validateNow();
				}
			}
		}
		
		/**
		 * Called by the modify action.
		 */
		private function modifyTemplate(event:AppEvent):void
		{
			var data:Object = event.data;
			if (data)
			{
				var i:int = _templates.indexOf(data);
				if (i > -1)
				{
					var template:GraphicTemplate = data as GraphicTemplate;
					
					// Create a modal graphic template editor
					var dialog:GraphicTemplateEditor = GraphicTemplateEditor(PopUpManager.createPopUp(this.parentDocument.map,GraphicTemplateEditor,true));
					dialog.TemplateGroups = this.templateGroups;
					dialog.Template = template;
					
					// Add handlers for dialog being cancelled, closed or move button pressed 
					dialog.addEventListener("graphicTemplateEditor_Save",newTemplate_SaveHandler);
					dialog.addEventListener("graphicTemplateEditor_SaveNew",newTemplate_SaveNewHandler);
					dialog.addEventListener("graphicTemplateEditor_Cancel",newTemplate_CancelHandler);
					dialog.addEventListener(CloseEvent.CLOSE,newTemplate_CloseHandler);
					
					// Show the move dialog				
					PopUpManager.centerPopUp(dialog);
				}
			}
		}
		
		/**
		 * Called when the template editor dialog is closed
		 */
		private function newTemplate_CloseHandler(event:CloseEvent):void
		{
			var dialog:GraphicTemplateEditor = GraphicTemplateEditor(event.target);
			newTemplate_Cancel(dialog); 
		}
		
		/**
		 * Called when the user updates an existing template.
		 */
		private function newTemplate_SaveHandler(event:Event):void
		{
			var dialog:GraphicTemplateEditor = GraphicTemplateEditor(event.target);
			newTemplate_Cancel(dialog); 

			// Refresh the displayed templates
			refreshTemplates();
			
			// Dispatch event to refresh the template list 
			dispatchEvent(new GraphicTemplatePickerEvent("templateListChange",this));
		}
		
		/**
		 * Called when a new template is created.
		 */
		private function newTemplate_SaveNewHandler(event:Event):void
		{
			var dialog:GraphicTemplateEditor = GraphicTemplateEditor(event.target);
			if (dialog.NewTemplate)
			{
				// Check for a template with this name
				graphicTemplates.push(dialog.NewTemplate);

				// Refresh the displayed templates
				refreshTemplates();

				// Alert that a new template has been added
				Alert.show("New Template Added","Template",Alert.OK);
			}
		}
		
		/** 
		 * Called when the user cancels an edit action.
		 */ 
		private function newTemplate_CancelHandler(event:Event):void
		{
			var dialog:GraphicTemplateEditor = GraphicTemplateEditor(event.target);
			newTemplate_Cancel(dialog); 
		}
		
		/** 
		 * Clears the handlers on the template editor dialog.
		 */ 
		private function newTemplate_Cancel(dialog:GraphicTemplateEditor):void
		{
			// removes the handlers for dialog being cancelled, closed or move button pressed 
			dialog.removeEventListener("graphicTemplateEditor_Save",newTemplate_SaveHandler);
			dialog.removeEventListener("graphicTemplateEditor_SaveNew",newTemplate_SaveNewHandler);
			dialog.removeEventListener("graphicTemplateEditor_Cancel",newTemplate_CancelHandler);
			dialog.removeEventListener(CloseEvent.CLOSE,newTemplate_CloseHandler);

			// Remove the dialog from the popup manager
			PopUpManager.removePopUp(dialog);
			
			// Call the skins change handler to update the skin.
			GraphicTemplatePickerSkin(this.skin).templateCollectionChangeHandler(null);
		}
		
		/**
		 * Clears the selected template.
		 */
		public function clearSelection():void
		{
			_selectedTemplate = null; 
			dispatchEvent(new GraphicTemplateEvent(GraphicTemplateEvent.SELECTED_TEMPLATE_CHANGE));
		}
	}
}
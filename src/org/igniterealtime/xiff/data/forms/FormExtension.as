/*
 * License
 */
package org.igniterealtime.xiff.data.forms
{
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * Implements the base functionality shared by all MUC extensions
	 * @see http://xmpp.org/extensions/xep-0004.html
	 */
	public class FormExtension extends Extension implements IExtension, ISerializable
	{
	    public static const FIELD_TYPE_BOOLEAN:String = "boolean";
	    public static const FIELD_TYPE_FIXED:String = "fixed";
	    public static const FIELD_TYPE_HIDDEN:String = "hidden";
	    public static const FIELD_TYPE_JID_MULTI:String = "jid-multi";
	    public static const FIELD_TYPE_JID_SINGLE:String = "jid-single";
	    public static const FIELD_TYPE_LIST_MULTI:String = "list-multi";
	    public static const FIELD_TYPE_LIST_SINGLE:String = "list-single";
	    public static const FIELD_TYPE_TEXT_MULTI:String = "text-multi";
	    public static const FIELD_TYPE_TEXT_PRIVATE:String = "text-private";
	    public static const FIELD_TYPE_TEXT_SINGLE:String = "text-single";
	
	    public static const REQUEST_TYPE:String = "form";
	    public static const RESULT_TYPE:String = "result";
	    public static const SUBMIT_TYPE:String = "submit";
	    public static const CANCEL_TYPE:String = "cancel";
	
	    public static const NS:String = "jabber:x:data";
	    public static const ELEMENT:String = "x";
	
		//private static var isStaticConstructed:Boolean = enable();
		//private static var staticDependencies:Array = [ ExtensionClassRegistry ];
	
		private var myItems:Array;
		private var myFields:Array;
	    private var myReportedFields:Array;
	
	    private var myInstructionsNode:XMLNode;
	    private var myTitleNode:XMLNode;
	
		/**
		 *
		 * @param	parent (Optional) The containing XMLNode for this extension
		 */
		public function FormExtension( parent:XMLNode=null )
		{
			super(parent);
			myItems = [];
			myFields = [];
			myReportedFields = [];
		}
	
		public function getNS():String
		{
			return FormExtension.NS;
		}
	
		public function getElementName():String
		{
			return FormExtension.ELEMENT;
		}
		
		public static function enable():Boolean
	    {
	        ExtensionClassRegistry.register(FormExtension);
	        return true;
	    }
		/**
		 * Called when this extension is being put back on the network.
		 * Perform any further serialization for Extensions and items
		 */
		public function serialize( parent:XMLNode ):Boolean
		{
			var node:XMLNode = getNode();
	
			for each (var field:FormField in myFields) {
				if (!field.serialize(node))
					return false;
			}
	
			if (parent != node.parentNode) {
				parent.appendChild(node.cloneNode(true));
			}
	
			return true;
		}
	
		public function deserialize( node:XMLNode ):Boolean
		{
			setNode(node);
	
			removeAllItems();
			removeAllFields();
	
			for each( var c:XMLNode in node.childNodes ) {
				var field:FormField;
				switch( c.nodeName )
				{
	                case "instructions": myInstructionsNode = c; break;
	                case "title": myTitleNode = c; break;
	                case "reported":
	                	for each(var reportedFieldXML:XMLNode in c.childNodes)
	                	{
	                		field = new FormField();
	                		field.deserialize(reportedFieldXML);
	                		myReportedFields.push(field);
	                	}
	                    break;
	
					case "item":
						var itemFields:Array = [];
	                    for each(var itemFieldXML:XMLNode in c.childNodes)
	                    {
	                        field = new FormField();
	                        field.deserialize(itemFieldXML);
	                        itemFields.push(field);
	                    }
	                    myItems.push(itemFields);
						break;
	
	                case "field":
	                    field = new FormField();
	                    field.deserialize(c);
	                    myFields.push(field);
	                    break;
				}
			}
			return true;
		}
	
	    /**
	     * This is an accessor to the hidden field type <code>FORM_TYPE</code>
	     * easily check what kind of form this is.
	     *
		 * @return String the registered namespace of this form type
	     * @see	http://xmpp.org/extensions/xep-0068.html
	     */
	    public function getFormType():String
	    {
	        // Most likely at the start of the array
	        for each(var field:FormField in myFields) {
	        	if(field.name == "FORM_TYPE")
	        		return field.value;
	        }
	        return "";
	    }
	
		/**
		 * Item interface to array of fields if they are contained in an "item" element
		 *
		 * @return Array containing Arrays of FormFields objects
		 */
	    public function getAllItems():Array
	    {
	        return myItems;
	    }
	
	    /**
		 *
	     * @param	value the name of the form field to retrieve
	     * @return	FormField the matching form field
	     */
	    public function getFormField(value:String):FormField
	    {
	    	 for each (var field:FormField in myFields)
	    	 {
			 	if (field.name == value)
			 		return field;
			 }
			 return null;
	    }
	
		/**
		 * Item interface to array of fields if they are contained in an "item" element
		 *
		 * @return Array of FormFields objects
		 */
	    public function getAllFields():Array
	    {
	        return myFields;
	    }
	
	    /**
	     * Sets the fields given a fieldmap object containing keys of field names
	     * and values of value arrays
	     *
	     * @param	fieldmap Object in format obj[key:String].value:Array
	     * availability Flash Player 7
	     */
	    public function setFields(fieldmap:Object):void
	    {
	        removeAllFields();
	        for (var f:String in fieldmap) {
	            var field:FormField = new FormField();
	            field.name = f;
	            field.setAllValues(fieldmap[f]);
	            myFields.push(field);
	        }
	    }
	
		/**
		 * Use this method to remove all items.
		 *
		 */
		public function removeAllItems():void
		{
			for each(var item:FormField in myItems) {
	            for each(var i:* in item) {
	                i.getNode().removeNode();
	                i.setNode(null);
	            }
			}
		 	myItems = [];
		}
		/**
		 * Use this method to remove all fields.
		 *
		 */
		public function removeAllFields():void
		{
			for each(var item:FormField in myFields) {
	            for each(var i:* in item) {
	                i.getNode().removeNode();
	                i.setNode(null);
	            }
			}
		 	myFields = [];
		}
	
	    /**
	     * Instructions describing what to do with this form
	     *
	     */
	    public function get instructions():String
	    {
	    	if(myInstructionsNode && myInstructionsNode.firstChild)
	    		return myInstructionsNode.firstChild.nodeValue;
	
	    	return null;
	    }
	
	
	    public function set instructions(val:String) :void
	    {
	        myInstructionsNode = replaceTextNode(getNode(), myInstructionsNode, "instructions", val);
	    }
	
	    /**
	     * The title of this form
	     *
	     */
	    public function get title():String
	    {
	    	if(myTitleNode && myTitleNode.firstChild)
	    		return myTitleNode.firstChild.nodeValue;
	
	    	return null;
	    }
	
	
	    public function set title(val:String) :void
	    {
	        myTitleNode = replaceTextNode(getNode(), myTitleNode, "Title", val);
	    }
	
	    /**
	     * Array of fields found in individual items due to a search query result
	     *
	     * @return	Array of FormField objects containing information about the fields
	     * in the fields retrieved by getAllItems
	     */
	    public function getReportedFields():Array
	    {
	        return myReportedFields;
	    }
	
	    /**
	     * The type of form.  May be one of the following:
	     *
	     * <code>FormExtension.REQUEST_TYPE</code>
	     * <code>FormExtension.RESULT_TYPE</code>
	     * <code>FormExtension.SUBMIT_TYPE</code>
	     * <code>FormExtension.CANCEL_TYPE</code>
	     *
	     */
	
	    public function get type():String
		{
			return getNode().attributes.type;
		}
	    public function set type(val:String) :void
	    {
	        // TODO ensure it is in the enumeration of "cancel", "form", "result", "submit"
	        // TODO Change the behavior of the serialization depending on the type
	        getNode().attributes.type = val;
	    }
	}
}
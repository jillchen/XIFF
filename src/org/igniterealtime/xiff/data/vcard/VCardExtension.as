/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *   
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 * 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.data.vcard
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;

	/**
	 * @see http://xmpp.org/extensions/xep-0054.html
	 */
	public class VCardExtension extends Extension implements IExtension, ISerializable
	{

		public static const ELEMENT_NAME:String = "vCard";

		public static const NS:String = "vcard-temp";

		/**
		 * Called when data is retrieved from the XMLSocket, use this method to extract any state into internal state.
		 * @param	node (XML) The node that should be used as the data container.
		 * @return	On success, return true.
		 */
		public function deserialize( node:XML ):Boolean
		{
			return true;
		}

		public function getElementName():String
		{
			return VCardExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return VCardExtension.NS;
		}

		/**
		 * Called when the library need to retrieve the state of the instance.
		 * If the instance manages its own state, then the state should be copied into the XML passed.
		 * If the instance also implements INodeProxy, then the parent should be verified against the
		 * parent XML passed to determine if the serialization is in the same namespace.
		 *
		 * @param	parentNode (XML) The container of the XML.
		 * @return	On success, return true.
		 */
		public function serialize( parentNode:XML ):Boolean
		{
			parentNode.appendChild( node );
			return true;
		}
	}
}

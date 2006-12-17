﻿package org.igniterealtime.xiff.conference{
	/*
	 * Copyright (C) 2003-2004 
	 * Nick Velloff <nick.velloff@gmail.com>
	 * Derrick Grigg <dgrigg@rogers.com>
	 * Sean Voisen <sean@mediainsites.com>
	 * Sean Treadway <seant@oncotype.dk>
	 *
	 * This library is free software; you can redistribute it and/or
	 * modify it under the terms of the GNU Lesser General Public
	 * License as published by the Free Software Foundation; either
	 * version 2.1 of the License, or (at your option) any later version.
	 * 
	 * This library is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	 * Lesser General Public License for more details.
	 * 
	 * You should have received a copy of the GNU Lesser General Public
	 * License along with this library; if not, write to the Free Software
	 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
	 *
	 */
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.muc.*;
	import org.igniterealtime.xiff.data.forms.FormExtension;
	import org.igniterealtime.xiff.events.MessageEvent;
	import org.igniterealtime.xiff.events.PresenceEvent;
	import org.igniterealtime.xiff.events.DisconnectionEvent;
	import org.igniterealtime.xiff.events.RoomEvent;
	import mx.collections.ArrayCollection;
	
	/**
	 * Broadcast when the room subject changes. The event object contains an attribute <code>subject</code> with the new subject as a String.
	 *
	 * @availability Flash Player 7
	 */
	[Event("subjectChange")]
	
	/**
	 * Broadcast whenever a new message intented for all room occupants is received. The event object contains an attribute <code>data</code>
	 * with the message as an instance of the <code>Message</code> class.
	 *
	 * @availability Flash Player 7
	 * @see org.igniterealtime.xiff.data.Message
	 */
	[Event("groupMessage")]
	
	/**
	 * Broadcast whenever a new private message is received. The event object contains an attribute <code>data</code>
	 * with the message as an instance of the <code>Message</code> class.
	 *
	 * @availability Flash Player 7
	 * @see org.igniterealtime.xiff.data.Message
	 */
	[Event("privateMessage")]
	
	/**
	 * Broadcast when you have entered the room and messages that are sent
	 * will be displayed to other users.  The room's role and affiliation will
	 * be visible from this point on.
	 *
	 * @availability Flash Player 7
	 */
	[Event("roomJoin")]
	
	/**
	 * Broadcast when the server acknoledges that you have the left the room
	 *
	 * @availability Flash Player 7
	 */
	[Event("roomLeave")]
	
	/**
	 * Broadcast when an affiliation list has been requested. The event object contains an array of org.igniterealtime.xiff.data.muc.MUCItems containing the JID and affiliation properties.
	 *
	 * To grant or revoke permissions based on this list, only send the changes you wish to make, calling grant/revoke with the new affiliation and existing JID.
	 */
	[Event("affiliations")]
	
	/**
	 * Broadcast when an administration action failed.  Contains the same fields as a
	 * <code>XMPPConnection.error</code> event.
	 *
	 * @see org.igniterealtime.xiff.core.XMPPConnection.error
	 */
	[Event("adminError")]
	
	/**
	 * Broadcast whenever an occupant joins the room. The event object contains an attribute <code>nickname</code>
	 * with the nickname of the occupant who joined.
	 *
	 * @availability Flash Player 7
	 */
	[Event("userJoin")]
	
	/**
	 * Broadcast whenever an occpant leaves the room. The event object contains an attribute <code>nickname</code>
	 * with the nickname of the occupant who left.
	 *
	 * @availability Flash Player 7
	 */
	[Event("userDeparture")]
	
	/**
	 * Broadcast when the preferred nickname already exists in the room.  The event object contains an attribute 
	 * <code>nickname</code> with the nickname already existing in the room.
	 *
	 * @availability Flash Player 7
	 */
	[Event("nickConflict")]
	
	/**
	 * Broadcast when a room configuration form is required to be completed.  This can occur during the creation of a room, or if a room configuration is requested.  The event object contains an attribute <code>data</code> which contains an objects that have the following attributes:
	 * 
	 * <code>instructions</code> - instruction for the use of form
	 * <code>title</code> - title of the configuration form
	
	 * <code>getAllFields()</code> - returns an array that contains the following properties:
	
	 * <code>label</code> - a friendly name for the field
	 * <code>name</code> - a computer readable identifier for the field used to identify this field in the result passed to <code>configure()</code>
	 * <code>type</code> - the type of the field to be displayed
	 * <code>getAllValues()</code> - an array of strings containing the default value(s)
	 * <code>getAllOptions()</code> - an array of objects that have the properties <code>label</code> and <code>value</code> that are used to display available choices
	 *
	 * @see org.igniterealtime.xiff.data.forms.FormExtension
	 * @see org.igniterealtime.xiff.data.forms.FormField
	 * @see configure
	 * @availability Flash Player 7
	 */
	[Event("configureForm")]
	
	/**
	 * Broadcast when an invite to this room has been declined by the invitee
	 *
	 * The event object has the following properties:
	 *
	 * <code>from</code> - the JID of the user initiating the invite
	 * <code>reason</code> - a string containing the reason to join the room
	 * <code>data</code> - the original message containing the decline
	 *
	 * @availability Flash Player 7
	 */
	[Event("declined")]
	
	/**
	 * Manages incoming and outgoing data from a conference room as part of multi-user conferencing (JEP-0045).
	 * You will need an instance of this class for each room that the user joins.
	 *
	 * You can also use your own, external data provider if you choose, by using the
	 * <code>setExternalDataProvider()</code> method. This is most useful for applications
	 * where the data provider might need to be a class other than an array with the Data Provider
	 * API decorations, like in the case of a Macromedia Central LCDataProvider. Overall,
	 * however, its probably a rare occurence.
	 *
	 * @since 2.0.0
	 * @author Sean Voisen
	 * @param connection An XMPPConnection instance that is providing the primary server connection
	 * @toc-path Conferencing
	 * @toc-sort 1
	 */
	public class Room extends ArrayCollection
	{
		public static var NO_AFFILIATION:String = MUC.NO_AFFILIATION;
		public static var MEMBER_AFFILIATION:String = MUC.MEMBER_AFFILIATION;
		public static var ADMIN_AFFILIATION:String = MUC.ADMIN_AFFILIATION;
		public static var OWNER_AFFILIATION:String = MUC.OWNER_AFFILIATION;
		public static var OUTCAST_AFFILIATION:String = MUC.OUTCAST_AFFILIATION;
		
		public static var NO_ROLE:String = MUC.NO_ROLE;
		public static var MODERATOR_ROLE:String = MUC.MODERATOR_ROLE;
		public static var PARTICIPANT_ROLE:String = MUC.PARTICIPANT_ROLE;
		public static var VISITOR_ROLE:String = MUC.VISITOR_ROLE;
	
		private var myConnection:XMPPConnection;
	    private var myJID:String;
		private var myNickname:String;
	    private var myPassword:String;
		private var myRole:String;
		private var myAffiliation:String;
	    private var myIsReserved:Boolean;
	    private var mySubject:String;
		
		private var active:Boolean;
		
		// Used to store nicknames in pending status, awaiting change approval from server
		private var pendingNickname:String;

		private static var staticConstructorDependencies:Array = [ 
	        FormExtension,
	        MUC
		]
	
		private static var roomStaticConstructed:Boolean = RoomStaticConstructor();
		
		public function Room( aConnection:XMPPConnection=null )
		{
			
			active = false;
			if (aConnection != null){
				setConnection( aConnection );
			}
		}
		
		private static function RoomStaticConstructor():Boolean
		{
	        MUC.enable();
	        FormExtension.enable();
			
			return true;
		}
		
		/**
		 * Sets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @param connection The XMPPConnection instance to use.
		 * @availability Flash Player 7
		 * @see org.igniterealtime.xiff.core.XMPPConnection
		 */
		public function setConnection( connection:XMPPConnection ):void
		{
			if (myConnection != null)
			{
				myConnection.removeEventListener(MessageEvent.MESSAGE, handleEvent);
				myConnection.removeEventListener(PresenceEvent.PRESENCE, handleEvent);
				myConnection.removeEventListener(DisconnectionEvent.DISCONNECT, handleEvent);	
			}
			
			
			myConnection = connection;
			
			myConnection.addEventListener(MessageEvent.MESSAGE, handleEvent, false, 0, true);
			myConnection.addEventListener(PresenceEvent.PRESENCE, handleEvent, false, 0, true);
			myConnection.addEventListener(DisconnectionEvent.DISCONNECT, handleEvent, false, 0, true);
		}
	
		/**
		 * Gets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @returns The XMPPConnection used
		 * @availability Flash Player 7
		 * @see org.igniterealtime.xiff.core.XMPPConnection
		 */
		public function getConnection():XMPPConnection
		{
			return myConnection;
		}
		 
	    /** 
	     * Joins a conference room based on the parameters specified by the room
	     * properties.  This call will create an instant room based on a default
	     * server configuration if the room doesn't exist.  To create and begin the
	     * configuration process of a reserved room, pass
	     * <code>true</code> to this method to begin the configuration process.  When
	     * The configuration is complete, the room will be unlocked for others to join.
	     * Listen to the <code>configureForm</code> event to handle and either return
	     * or cancel the configuration of the room.
		 *
	     * @param createReserved (optional) Set to true if you wish to create and configure a reserved room
		 * @availability Flash Player 7
		 * @return A boolean indicating whether the join attempt was successfully sent.
		 */
		public function join(createReserved:Boolean = false):Boolean
		{
			if( !isActive() && myConnection.isActive() ) {
	            //trace("Room: join: " + roomName);
	            myIsReserved = createReserved == true ? true : false;
	
				var joinPresence:Presence = new Presence( getUserJID() );
	            var muc:MUCExtension = new MUCExtension();
	           
	            if( password != null ) {
	                muc.password = password;
	            }
	
				joinPresence.addExtension(muc);
				myConnection.send( joinPresence );
				return true;
			}
			
			return false;
		}
		 
		/**
		 * Leaves the current conference room, assuming that the user has joined one.
		 * If the user is not currently in a room, this method does nothing.
		 *
		 * @availability Flash Player 7
		 */
		public function leave():void
		{
			if( isActive() ) {
				var leavePresence:Presence = new Presence( getUserJID(), null, Presence.UNAVAILABLE_TYPE );
				myConnection.send( leavePresence );
				
				// Clear out the roster items
				removeAll();
				myConnection.removeEventListener(MessageEvent.MESSAGE, handleEvent);
				myConnection.removeEventListener(PresenceEvent.PRESENCE, handleEvent);
				myConnection.removeEventListener(DisconnectionEvent.DISCONNECT, handleEvent);
			}
		}
		
		/**
		 * Sends a message to the conference room.
		 *
		 * @param body The message body
		 * @param htmlBody (Optional) The message body with HTML formatting
		 * @availability Flash Player 7
		 */
		public function sendMessage( body:String=null, htmlBody:String=null ):void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID(), null, body, htmlBody, Message.GROUPCHAT_TYPE );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Sends a private message to a specific participant in the conference room.
		 *
		 * @param recipientNickname The conference room nickname of the recipient who should receive the private message
		 * @param body The message body
		 * @param htmlBody (Optional) The message body with HTML formatting
		 * @availability Flash Player 7
		 */
		public function sendPrivateMessage( recipientNickname:String, body:String=null, htmlBody:String=null ) : void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID() + "/" + recipientNickname, null, body, htmlBody, Message.CHAT_TYPE );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Changes the subject in the conference room.
	     *
	     * You must be joined to the room to change the subject
		 *
		 * @param newSubject The new subject
		 * @availability Flash Player 7
		 */
		public function changeSubject( newSubject:String ):void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID(), null, null, null, Message.GROUPCHAT_TYPE, newSubject );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Kicks an occupant out of the room, assuming that the user has necessary permissions to do so. If the user does not, the server will return an error.
		 *
		 * @param occupantNick The nickname of the room occupant to kick
		 * @param reason The reason for the kick
		 * @availability Flash Player 7
		 */
		public function kickOccupant( occupantNick:String, reason:String ):void
		{
			if( isActive() ) {
				var tempIQ:IQ = new IQ( getRoomJID(), IQ.SET_TYPE, XMPPStanza.generateID("kick_occupant_") );
				var ext:MUCAdminExtension = new MUCAdminExtension(tempIQ.getNode());
				//ext.addItem(null, MUC.NO_ROLE, null, null, null, reason);
				ext.addItem(null, MUC.NO_ROLE, occupantNick, null, null, reason); 
				tempIQ.addExtension(ext);
				myConnection.send( tempIQ );
			}
		}
		
		/**
		 * In a moderated room, sets voice status to a particular occupant, assuming the user has the necessary permissions to do so.
		 *
		 * @param occupantNick The nickname of the occupant to give voice
		 * @param voice Whether to add voice (true) or remove voice (false)
		 * @availability Flash Player 7
		 */
		public function setOccupantVoice( occupantNick:String, voice:Boolean ):void
		{
			if( isActive() ) {
				var tempIQ:IQ = new IQ( getRoomJID(), IQ.SET_TYPE, XMPPStanza.generateID("voice_") );
				var ext:MUCAdminExtension = new MUCAdminExtension(tempIQ.getNode());
				ext.addItem(null, voice ? MUC.PARTICIPANT_ROLE : MUC.VISITOR_ROLE);
				tempIQ.addExtension(ext);
				myConnection.send( tempIQ );
			}
		}
	
	    /**
	     * Invites a user that is not currently a member of this room to this room.
	     *
	     * You must be joined to the room and have appropriate permissions to invite 
	     * other memebers, as the room will format and send the invite message to 
	     * the destination user rather that you sending the invite directly to the user.
	     *
	     * To listen to events, add an event listener on your XMPPConnection on the
	     * <code>invite</code> event.
	     *
	     * @param jid A string JID of the user to invite
	     * @param reason A string describing why you would like to invite the user
		 * @availability Flash Player 7
	     */
	    public function invite(jid:String, reason:String):void
	    {
	        var msg:Message = new Message(getRoomJID())
	        var muc:MUCUserExtension = new MUCUserExtension();
	
	        muc.invite(jid, undefined, reason);
	
	        msg.addExtension(muc);
	        myConnection.send(msg);
	    }
	
	    /**
	     * Actively decline an invitation.  You can optionally ignore invitations
	     * but if you choose to decline an invitation, you call this method on
	     * a room instance that represents the room the invite originated from.
	     *
	     * You do not need to be joined to this room to decline an invitation
	     *
	     * Note: mu-conference-0.6 currently does not allow users to send decline
	     * messages without joining first.  If using this version of conferencing
	     * software, it is best to ignore invites.
	     *
	     * @param reason A string describing why the invitiation was declined
		 * @availability Flash Player 7
	     */
	    public function decline(jid:String, reason:String):void
	    {
	        var msg:Message = new Message(getRoomJID())
	        var muc:MUCUserExtension = new MUCUserExtension();
	
	        muc.decline(jid, undefined, reason);
	
	        msg.addExtension(muc);
	        myConnection.send(msg);
	    }
	
		/**
		 * Gets the fully qualified room name (room@server) of the current room.
		 *
		 * @return The fully qualified room name
		 * @availability Flash Player 7
	     * @depreciated
		 */
		public function getFullRoomName():String
		{
	        return getRoomJID();
		}
	
	    /**
	     * Get the JID of the room like XMPPConnection.getJID() used to send room messages
	     *
	     * @return the room's JID
		 * @availability Flash Player 7
	     */
	    public function getRoomJID():String
	    {
	        return myJID;
	    }
		
	    /**
	     * Set the JID of the room in the form "room@conference.server"
	     *
	     * @return the room's JID
		 * @availability Flash Player 7
	     */
	    public function setRoomJID(jid:String):void
	    {
	        myJID = jid;
	    }
		
	    /**
	     * Get the JID of the user in the room like XMPPConnection.getJID() used to receive messages
	     *
	     * @return your JID in the room 
		 * @availability Flash Player 7
	     */
	    public function getUserJID():String
	    {
	        return getRoomJID() + "/" + nickname;
	    }
		
		/**
		 * Gets the users role in the conference room. 
		 * Possible roles are "visitor", "participant", "moderator" or no defined role.
		 *
		 * @return The user's role
		 * @availability Flash Player 7
		 */
		public function getRole():String
		{
			return myRole;
		}
		
		/**
		 * Gets the user's affiliation for this room.
		 * Possible affiliations are "owner", "admin", "member", and "outcast". It is also possible to have no defined affiliation.
		 *
		 * @return The user's affiliation
		 * @availability Flash Player 7
		 */
		public function getAffiliation():String
		{
			return myAffiliation;
		}
	
		/**
		 * Determines whether the connection to the room is active - that is, the user is connected and has joined the room.
		 *
		 * @return True if the connection is active; false otherwise
		 * @availability Flash Player 7
		 */
		public function isActive():Boolean
		{
			return active;
		}

		private function handleEvent( eventObj:Object ):void
		{
			switch( eventObj.type )
			{
				case "message":
					var msg:Message = eventObj.data;
					
					// Check to see that the message is from this room
					if( isThisRoom( msg.from ) ) {
						var e:RoomEvent;
						if ( msg.type == Message.GROUPCHAT_TYPE ) {
							// Check for a subject change
							if( msg.subject != null ) {
								mySubject = msg.subject;
								e = new RoomEvent(RoomEvent.SUBJECT_CHANGE);
								e.subject = msg.subject;
								dispatchEvent(e);
							}
							else {
								e = new RoomEvent(RoomEvent.GROUP_MESSAGE);
								e.data = msg;
								dispatchEvent(e);
							}
						} else if ( msg.type == Message.NORMAL_TYPE ) {
							try
							{
								var form:Array = msg.getAllExtensionsByNS(FormExtension.NS)[0];
								if (form) {
									e = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
									e.data = form;
									dispatchEvent(e);
								}
							}
							catch (e:Error)
							{
								trace("Error : null trapped. Resuming.");
							}
						}
					}
	
					// It could be a private message via the conference
					else if( isThisUser(msg.to) && msg.type == Message.CHAT_TYPE ) {
						e = new RoomEvent(RoomEvent.PRIVATE_MESSAGE);
						e.data = msg;
						dispatchEvent(e);
	                } 
	
	                // Could be an decline to a previous invite
	                else {
	                	try
	                	{
	                		var muc:MUCUserExtension = msg.getAllExtensionsByNS(MUCUserExtension.NS)[0];
		                	if (muc && muc.type == MUCUserExtension.DECLINE_TYPE) 
		                	{
		                    	e = new RoomEvent(RoomEvent.DECLINED);
		                    	e.from = muc.reason;
		                    	e.reason = muc.reason;
		                    	e.data = msg;
		                    	dispatchEvent(e);
		                    }
	                	}
	                	catch (err:Error) 
	                	{
	                		trace("Error : null trapped. Resuming.");
	                	}
	                }
					break;
					
				case "presence":
					var presence:Presence = eventObj.data;
	
	                //trace("ROOM presence: " + presence.from + " : " + nickname);
	
					if (presence.type == Presence.ERROR_TYPE) {
						switch (presence.errorCode) {
							case 409:
								e = new RoomEvent(RoomEvent.NICK_CONFLICT);
								e.nickname = nickname;
								dispatchEvent(e);
								break;
						}
					} else if( isThisRoom( presence.from ) ) {
						// If the presence has our pending nickname, nickname change went through
						if( presence.from.split( "/" )[1] == pendingNickname ) {
							myNickname = pendingNickname;
							pendingNickname = null;
						}
						try
						{
							var user:MUCUserExtension = presence.getAllExtensionsByNS(MUCUserExtension.NS)[0];
		                    if( user.statusCode == 201 ) {
		                        unlockRoom(myIsReserved);
		                    }
						}
	                    catch (e:Error)
	                    {
	                    	trace("Error : null trapped. Resuming.");
	                    }
	
						updateRoomRoster( presence );
	
						if (presence.type == Presence.UNAVAILABLE_TYPE && isActive() && isThisUser(presence.from)) {
							//trace("Room: becoming inactive: " + presence.getNode());
							active = false;
							e = new RoomEvent(RoomEvent.ROOM_LEAVE);
							dispatchEvent(e);
						}
					}
					break;
	
					
				case "disconnection":
					// The server disconnected, so we are no longer active
					active = false;
					removeAll();
					e = new RoomEvent(RoomEvent.ROOM_LEAVE);
					dispatchEvent(e);
					break;
			}
		}
	
	    /*
	     * Room owner (creation/configuration/destruction) methods
	     */
	
	    private function unlockRoom( isReserved:Boolean ):void
	    {
	        // http://www.jabber.org/jeps/jep-0045.html#createroom
	
	        if( isReserved ) {
	            requestConfiguration();
	        } else {
	            // Send an empty configuration form to open the instant room
	
	            // The IQ.result for this request will signify that the room is
	            // unlocked.  Sometimes there are messages that are sent before
	            // the request is returned.  It may be smart to either block those
	            // messages, or provide 2 events "beginConfiguration" and "endConfiguration"
	            // so the application can decide to block configuration messages
	
	            var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	            var owner:MUCOwnerExtension = new MUCOwnerExtension();
	            var form:FormExtension = new FormExtension();
	
	            form.type = FormExtension.SUBMIT_TYPE;
	
	            owner.addExtension(form);
	            iq.addExtension(owner);
	            myConnection.send(iq);
	        }
	    }
	
		/**
		 * Requests a configuration form from the room.  Listen to <code>configureForm</code>
	     * event to fill out the form then call either <code>configure</code> or
	     * <code>cancelConfiguration</code> to complete the configuration process
	     *
	     * You must be joined to the room and have the owner affiliation to request 
	     * a configuration form
		 *
	     * @see configureForm
	     * @see configure
	     * @see cancelConfiguration
		 * @availability Flash Player 7
		 */
	    public function requestConfiguration():void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.GET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_requestConfiguration";
	        iq.addExtension(owner);
	
	        myConnection.send(iq);
	    }
	
	    /*
	     * IQ callback when form is ready
	     */
	    private function finish_requestConfiguration(iq:IQ):void
	    {
	    	try
			{
				var owner:MUCOwnerExtension = iq.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
		        var form:FormExtension = owner.getAllExtensionsByNS(FormExtension.NS)[0];
		
		        if( form.type == FormExtension.REQUEST_TYPE ) {
		        	var e:RoomEvent = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
		        	e.data = form;
		        	dispatchEvent(e);
		        }
			}
            catch (e:Error)
            {
            	trace("Error : null trapped. Resuming.");
            }
	        
	    }
	
		/**
		 * Sends a configuration form to the room.  Accepts a fieldmap hash which
	     * is an object with keys being the variables and the values being arrays.
	     * For single value fields, use a single element array
	     *
	     * You must be joined and have owner affiliation to configure the room
	     *
	     * @see configureForm
		 * @availability Flash Player 7
		 */
	    public function configure(fieldmap:Object):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
			var form:FormExtension;
	
			if (fieldmap is FormExtension) {
				form = FormExtension(fieldmap);
			} else {
				form = new FormExtension();
				fieldmap["FORM_TYPE"] = [MUCOwnerExtension.NS];
				form.setFields(fieldmap);
			}
			form.type = FormExtension.SUBMIT_TYPE;
			owner.addExtension(form);
	
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
	
		/**
		 * Cancels the configuration process.  The room may still be locked if
	     * you cancel the configuration process when attempting to join a
	     * reserved room.
	     *
	     * You must be joined to the room and have the owner affiliation to 
	     * configure the room
	     *
	     * @see configureForm
	     * @see join
		 * @availability Flash Player 7
		 */
	    public function cancelConfiguration():void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	        var form:FormExtension = new FormExtension();
	
	        form.type = FormExtension.CANCEL_TYPE;
	
	        owner.addExtension(form);
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
	
	    /**
	     * Grants permissions on a room one or more JIDs by setting the 
	     * affiliation of a user based * on their JID.  Use one of the 
	     * following affiliations:
	     * 
	     * <code>Room.MEMBER_AFFILIATION</code>
	     * <code>Room.ADMIN_AFFILIATION</code>
	     * <code>Room.OWNER_AFFILIATION</code>
	     *
	     * If the JID currenly has an existing affiliation, then the existing 
	     * affiliation will be replaced with the one passed.
	     * 
	     * If the process could not be completed, the room will dispatch the event
	     * adminError
	     * 
	     * @category Admin
	     * @see revoke
	     * @see ban
		 * @availability Flash Player 7
	     */
	    public function grant(affiliation:String, jids:Array, callback:Function):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_admin";
	        iq.callback = callback;
	
	        for (var i:int=0; i < jids.length; i++) {
	            owner.addItem(affiliation, null, null, jids[i], null, null);
	        }
	
	        iq.addExtension(owner);
	        getConnection().send(iq);
	    }
	
	    /**
	     * Revokes all affiliations from the JIDs.  This is the same as:
	     * grant(Room.NO_AFFILIATION, jids)
	     * 
	     * If the process could not be completed, the room will dispatch the event
	     * adminError
	     *
	     * Note: if the JID is banned from this room, then this will also revoke
	     * their banned status.
	     * 
	     * @category Admin
	     * @see grant
	     * @see ban
	     * @see allow
		 * @availability Flash Player 7
	     */
	    public function revoke(jids:Array, callback:Function):void
	    {
	        grant(Room.NO_AFFILIATION, jids, callback);
	    }
	
	    /**
	     * Bans an array of JIDs from entering the room.  This is the same as:
	     * Room.grant(OUTCAST_AFFILIATION, jid)
	     *
	     * If the process could not be completed, the room will dispatch the event
	     * adminError
	     * 
	     * @category Admin
	     * @see grant
	     * @see allow
		 * @availability Flash Player 7
	     */
	    public function ban(jids:Array, callback:Function):void
	    {
	        grant(Room.OUTCAST_AFFILIATION, jids, callback);
	    }
	
	    /**
	     * Allow a previously banned JIDs to enter this room.  This is the same as:
	     * Room.grant(NO_AFFILIATION, jid)
	     *
	     * If the process could not be completed, the room will dispatch the event
	     * adminError
	     * 
	     * @category Admin
	     * @see revoke
	     * @see ban
		 * @availability Flash Player 7
	     */
	    public function allow(jids:Array, callback:Function):void
	    {
	        grant(Room.NO_AFFILIATION, jids, callback);
	    }
	
	    /*
	     * The default handler for admin IQ messages
	     * Dispatches the adminError event if anything went wrong
	     */
	    private function finish_admin(iq:IQ):void
	    {
	        if (iq.type == IQ.ERROR_TYPE) {
	        	var e:RoomEvent = new RoomEvent(RoomEvent.ADMIN_ERROR);
	        	e.errorCondition = iq.errorCondition;
	        	e.errorMessage = iq.errorMessage;
	        	e.errorType = iq.errorType;
	        	e.errorCode = iq.errorCode;
	        	dispatchEvent(e);
	        }
	    }
	
	    /**
	     * Requests an affiliation list for a given affiliation with with room.
	     * This will either broadcast the event <code>affiliations</code> or 
	     * <code>adminError</code> depending on the result of the request
	     *
	     * Use one of the following affiliations:
	     *
	     * <code>Room.NO_AFFILIATION</code>
	     * <code>Room.OUTCAST_AFFILIATION</code>
	     * <code>Room.MEMBER_AFFILIATION</code>
	     * <code>Room.ADMIN_AFFILIATION</code>
	     * <code>Room.OWNER_AFFILIATION</code>
	     *
	     * @category Admin
	     * @see revoke
	     * @see grant
	     * @see affiliations
		 * @availability Flash Player 7
	     */
	    public function requestAffiliations(affiliation:String) : void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.GET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_requestAffiliates";
	
	        owner.addItem(affiliation);
	
	        iq.addExtension(owner);
	        getConnection().send(iq);
	    }
	
	    private function finish_requestAffiliates(iq:IQ):void
	    {
	        finish_admin(iq);
	        if (iq.type == IQ.RESULT_TYPE) {
	        	
	        	try
	        	{
		            var owner:MUCOwnerExtension = iq.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
		            var items:Array = owner.getAllItems();
		            // trace("Affiliates: " + items);
		            var e:RoomEvent = new RoomEvent(RoomEvent.AFFILIATIONS);
		            e.data = items;
		            dispatchEvent(e);
	        	}
	        	catch (e:Error)
	        	{
	        		trace("Error : null trapped. Resuming.");
	        	}

	        }
	    }
	
		/**
		 * Destroys a reserved room.  If the room has been configured to be persistent,
	     * then it is optional that the server will permanently remove the room.
	     *
	     * @param reason A short description of why the room is being destroyed
	     * @param alternateJID A JID for current members to use as an alternate room to join after the room has been destroyed.  Like a postal forwarding address.
		 * @availability Flash Player 7
		 */
	    public function destroy(reason:String, alternateJID:String=null, callback:Function=null):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callback = callback;
	        owner.destroy(reason, alternateJID);
	
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
		
		private function updateRoomRoster( aPresence:Presence ):void
		{
			try
			{
				var userNickname:String = aPresence.from.split( "/" )[1];
				var userExts:Array = aPresence.getAllExtensionsByNS(MUCUserExtension.NS);
		        var item:MUCItem = userExts[0].getAllItems()[0];
				var e:RoomEvent;
				
				if ( isThisUser( aPresence.from ) ) {
		            myAffiliation = item.affiliation;
		            myRole = item.role;
		
					if (!isActive() && aPresence.type != Presence.UNAVAILABLE_TYPE) {
						//trace("Room: becoming active: " + presence.getNode());
						active = true;
						e = new RoomEvent(RoomEvent.ROOM_JOIN);
						dispatchEvent(e);
					}
				}
		
		        for( var i:int=0; i < length; i++ ) {
					//trace("Room: updateRoomRoster: checking: " + getItemAt(i).nickname);
		
		            if( getItemAt( i ).nickname == userNickname ) {
		                
		                // If the user left, remove the item
		                if( aPresence.type == Presence.UNAVAILABLE_TYPE ) {
							//trace("Room: updateRoomRoster: leaving room: " + userNickname);
		
		                    // Notify listeners that a user has left the room
		                    e = new RoomEvent(RoomEvent.USER_DEPARTURE);
		                    e.nickname = userNickname;
		                    dispatchEvent(e);
		                    removeItemAt (i);
		
		                } else if (item != null) {
		                	
		                	var o:Object = getItemAt(i);
		                	o.affiliation = item.affiliation;
		                	o.role = item.role;
		                	o.show = aPresence.show != null ? aPresence.show : Presence.SHOW_NORMAL;
		                }
		                return;
		            }
	        	}
		        
		        // Wasn't found, so add it
		        if( aPresence.type != Presence.UNAVAILABLE_TYPE ) {
					addToRoomRoster( userNickname, 
						aPresence.show != null ? aPresence.show : Presence.SHOW_NORMAL, 
						item.affiliation, item.role, item.jid );
		
		            if( userNickname != nickname ) {
		            	e = new RoomEvent(RoomEvent.USER_JOIN);
		            	e.nickname = userNickname;
		            	dispatchEvent(e);
		            } 
		        }
			}
			catch (e:Error)
			{
				trace("Error : null trapped. Resuming.");
			}
		}
		
		private function addToRoomRoster( nickname:String, show:String, affiliation:String, role:String, jid:String ):void
		{
			addItem({nickname:nickname, show:show, affiliation:affiliation, role:role, jid:jid});
		}
		
		/**
		 * Tests if the parameter comes is the same as this room
		 *
		 * @param the room JID to test
		 * @return true if the passed JID matches the getRoomJID
		 * @availability Flash Player 7
		 */
		public function isThisRoom( sender:String ):Boolean
		{
			// Checks to see that sender is this room
			return sender.split( "/" )[0].toLowerCase() == getRoomJID().toLowerCase();
		}
	
		/**
		 * Tests if the parameter comes is the same user as that connected to the room
		 *
		 * @param the room JID to test
		 * @return true if the passed JID matches the getUserJID()
		 * @availability Flash Player 7
		 */
		public function isThisUser( sender:String ):Boolean
		{
			// Case insensitive check that the sender is the same as the user
			return sender.toLowerCase() == getUserJID().toLowerCase();
		}
		
		/**
		 * The conference server to use for this room. Usually, this is a subdomain of the primary XMPP server, like conference.myserver.com.
		 *
		 * @availability Flash Player 7
		 */
		public function get conferenceServer():String
		{
			return myJID.split("@")[1];
		}
		 
		public function set conferenceServer( aServer:String ):void
		{
			setRoomJID(roomName + "@" + aServer);
		}
		
		/**
		 * The room name that should be used when joining.
		 *
		 * @availability Flash Player 7
		 */
		public function get roomName():String
		{
			return myJID.split("@")[0];
		}
		
		public function set roomName( aName:String ):void
		{
			setRoomJID(aName + "@" + conferenceServer);
		}
		
		/**
		 * The nickname to use when joining.
		 *
		 * @availability Flash Player 7
		 */
		public function get nickname():String
		{
			return myNickname == null ? myConnection.username : myNickname;
		}
		
		public function set nickname( theNickname:String ):void
		{	
			if( isActive() ) {
				pendingNickname = theNickname;
				// var tempPresence:Presence = new Presence( getUserJID() );
				var tempPresence:Presence = new Presence( getUserJID() + "/" + pendingNickname );
				myConnection.send( tempPresence );
			}
			else {
				myNickname = theNickname;
			}
		}
	
	    public function get password():String
	    {
	        return myPassword;
	    }
	
	    public function set password(aPassword:String):void
	    {
	        myPassword = aPassword;
	    } 
	
	    public function get subject():String
	    {
	        return mySubject;
	    }
	}
}
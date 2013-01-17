unit XMPPEvent;

interface
uses
  xmpp.client.IQ,xmpp.client.Presence,xmpp.iq.RosterItem,xmpp.iq.agentiq,Element,xmpp.client.Message
  ,XMPPConst,SysUtils,xmpp.iq.RegisterEventArgs,xmpp.client.sasl.SaslEventArgs
  ,Jid;
type
  TJidHandler=procedure(sender:TObject;jid:Tjid) of object;
  TIqHandler=procedure(sender:TObject;iq:TIQ) of object;
  TPresenceHandler=procedure(sender:TObject;pres:TPresence) of object;
  TMessageHandler=procedure(sender:TObject;msg:TMessage) of object;
  TRosterHandler=procedure(sender:TObject;item:TRosterItem) of object;
  TAgentHandler=procedure(sender:TObject;agent:TAgent) of object;
  TXmppElementHandler=procedure(sender:TObject;e:TElement) of object;
  TXmlHandler=procedure(sender:TObject;xml:string)of object;
  TXmppConnectionStateHandler=procedure(sender:TObject;state:TXmppConnectionState)of object;
//  OnSocketDataHandler=procedure(sender:TObject;bt:TBytes;len:Integer)of object;
//  OnSocketXmlHandler=procedure(sender:TObject;xml:string)of object;
  TErrorHandler=procedure(sender:TObject;ex:string)of object;
//  StreamHandler=procedure(sender:TObject;e:TElement) of object;
//  StreamError=procedure(sender:TObject;ex:Exception)of object;

  TGrabberCB=procedure(sender:TObject;iq:TElement;data:pointer) of object;
  TIqCB=procedure(sender:TObject;iq:TIQ;const data:pointer) of object;
  TMessageCB=procedure(sender:TObject;msg:TMessage;data:pointer) of object;
  TPresenceCB=procedure(sender:TObject;pres:TPresence;data:pointer) of object;
  TRegisterEventHandler=procedure (sender:TObject;args:TRegisterEventArgs) of object;
  TSaslEventHandler=procedure(sender:TObject;args:TSaslEventArgs) of object;
  TProgressEventHandler=procedure(sender:TObject;len:Int64) of object;
implementation

end.

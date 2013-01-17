unit XmppClient;

interface
uses
  XmppClientExtension,XmppClientConnection,Element,XMPPEvent,classes,XMPPConst,xmpp.client.iq;
type
  TXmppClient=class
  private
    xmpp:TXmppClientConnection;
    FOnXmppConnectionStateChanged:TXmppConnectionStateHandler;
    FOnError:TErrorHandler;
    FOnIq:TIqHandler;
    FOnMessage:Tmessagehandler;

    FOnPresence:TPresenceHandler;
    FOnLogin,FOnClose:TNotifyEvent;
    FOnAuthError:TXmppElementHandler;
    procedure StreamParserElement(sender:TObject;e:TIQ);
    procedure DoChangeXmppConnectionState(sender:TObject;state:TXmppConnectionState);
    procedure SocketOnConnect(sender:Tobject);
    procedure SocketOnDisconnect(sender:Tobject);
    procedure SocketOnError(sender:TObject;ex:string);

    //void _q_reconnect();
  public
    property OnLogin:TNotifyEvent read FOnLogin write FOnLogin;
    property OnAuthError:TXmppElementHandler read FOnAuthError write FOnAuthError;
    property OnIq:TIqHandler read FOnIq write FOnIq;
    property OnPresence:TPresenceHandler read FOnPresence write FOnPresence;
    property OnMessage:TMessageHandler read FOnMessage write FOnMessage;
    property OnClose:TNotifyEvent read FOnClose write FOnClose;
    property OnError:TErrorHandler read FOnError write FOnError;
    property OnXmppConnectionStateChanged:TXmppConnectionStateHandler read FOnXmppConnectionStateChanged write FOnXmppConnectionStateChanged;
    constructor Create;
    destructor Destory;
    procedure connectToServer(const jid,password:string);
    procedure disconnectFromServer();
    procedure sendPacket(const tag:Telement);
    procedure sendMessage(const bareJid,message:string);
  end;
//  TXmppClientExtension=class
//    QXmppClientExtension();
//    virtual ~QXmppClientExtension();
//
//    virtual QStringList discoveryFeatures() const;
//    virtual QList<QXmppDiscoveryIq::Identity> discoveryIdentities() const;
//virtual bool handleStanza(const QDomElement &stanza) = 0;
//
//protected:
//    QXmppClient *client();
//    virtual void setClient(QXmppClient *client);
//  end;

implementation

{ TXmppClient }

procedure TXmppClient.connectToServer(const jid, password: string);
begin

end;

constructor TXmppClient.Create;
begin
  xmpp := TXmppClientConnection.Create;
  xmpp.OnError := SocketOnError;
//  xmpp.OnReadXml := DoOnReadXml;
//  xmpp.OnWriteXml := DoOnWriteXml;
  xmpp.OnIq := StreamParserElement;
  xmpp.OnLogin := SocketOnConnect;
  xmpp.OnClose := SocketOnDisconnect;
  xmpp.OnXmppConnectionStateChanged := DoChangeXmppConnectionState;
end;

destructor TXmppClient.Destory;
begin
  xmpp.Free;
end;

procedure TXmppClient.disconnectFromServer;
begin

end;

procedure TXmppClient.DoChangeXmppConnectionState(sender:TObject;state: TXmppConnectionState);
begin

end;

procedure TXmppClient.sendMessage(const bareJid, message: string);
begin

end;

procedure TXmppClient.sendPacket(const tag: Telement);
begin

end;

procedure TXmppClient.SocketOnConnect(sender: Tobject);
begin
  inherited;

end;

procedure TXmppClient.SocketOnDisconnect(sender: Tobject);
begin
  inherited;

end;

procedure TXmppClient.SocketOnError(sender: TObject; ex: string);
begin
  inherited;

end;

procedure TXmppClient.StreamParserElement(sender: TObject; e: TIQ);
begin

end;

end.

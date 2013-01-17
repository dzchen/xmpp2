unit Xmpp.Client.sasl.SaslHandler;

interface
uses
  XMPPEvent,XMPPConst,xmpp.sasl.Mechanism,Classes,Element,xmpp.client.IQ,Jid,xmpp.Iq.SessionIq,xmpp.Iq.BindIq
  ,xmpp.stream.Features,xmpp.client.sasl.SaslEventArgs,SysUtils
  ,xmpp.sasl,XmppConnection,Xmpp.Client.sasl.Mechanism;
type
  TSaslHandler=class
  private
    _mechanism:xmpp.Client.sasl.Mechanism.TMechanism;
    _connection:TXmppConnection;
    disposed:Boolean;

    FOnSaslStart:TSaslEventHandler;
    FOnSaslEnd:tnotifyevent;
    procedure DoBind();
    procedure BindResult(sender:TObject;iq:TIQ;const data:pointer);
    procedure SessionResult(sender:TObject;iq:TIQ;const data:pointer);

  public
    property OnSaslStart:TSaslEventHandler read FOnSaslStart write FOnSaslStart;
    property OnSaslEnd:TNotifyEvent read FOnSaslEnd write FOnSaslEnd;
    constructor Create(conn:TXmppConnection);
    destructor Destroy;override;
    procedure OnStreamElement(sender:TObject;e:TElement);

  end;

implementation
uses
  XmppClientConnection;

{ TSaslHandler }

procedure TSaslHandler.BindResult(sender: TObject; iq: TIQ; const data: pointer);
var
  bind:TElement;
  jid:TJid;
  siq:TSessionIq;
begin
  if iq.IqType='result' then
  begin
    bind:=TElement(iq.GetFirstTag(Tbind.TagName));
    if Assigned(bind) then
    begin
      jid:=TBind(bind).Jid;
      TXmppClientConnection(_connection).Resource:=jid.resource;
      TXmppClientConnection(_connection).UserName:=jid.user;
    end;
    _connection.DoChangeXmppConnectionState(Binded);
    TXmppClientConnection(_connection).Binded:=true;
    TXmppClientConnection(_connection).DoRaiseEventBinded;
    _connection.DoChangeXmppConnectionState(StartSession);
    siq:=TSessionIq.Create('set',TJID.Create(_connection.Server));
    TXmppClientConnection(_connection).IqGrabber.SendIq(siq,sessionresult,nil);
  end
  else if iq.IqType='error' then
  begin

  end;
end;

constructor TSaslHandler.Create(conn:TXmppConnection);
begin
  _connection:=conn;
end;

destructor TSaslHandler.Destroy;
begin
  _mechanism.Free;
  _mechanism:=nil;
end;

procedure TSaslHandler.DoBind;
var
  biq:TBindIQ;
begin
  _connection.DoChangeXmppConnectionState(Binding);
  if (TXmppClientConnection(_connection).Resource='') then
    biq:=TBindIq.Create('set',TJID.Create(_connection.Server))
  else
    biq:=TBindIq.Create('set',tjid.Create(_connection.Server),TXmppClientConnection(_connection).Resource);
  TXmppClientConnection(_connection).IqGrabber.SendIq(biq,Bindresult,nil);
end;

procedure TSaslHandler.OnStreamElement(sender: TObject; e: TElement);
var
  f:TFeatures;
  args:TSaslEventArgs;
  biq:TBindIq;
begin
  if (_connection.XmppConnectionState=Securing)or(_connection.XmppConnectionState=StartCompression) then
    exit;
  if e.IsTagEqual(TFeatures.TagName) then
  begin
    f:=TFeatures(e);
    if not TXmppClientConnection(_connection).Authenticated then
    begin
      args:=TSaslEventArgs.Create(f.Mechanisms);
      if Assigned(FOnSaslStart) then
        FOnSaslStart(self,args);
      if args.Auto then
      begin
        if Assigned(f.Mechanisms) then
        begin
          if (TXmppClientConnection(_connection).UseStartTLS=False) and (TXmppClientConnection(_connection).UseSSL=False) and f.Mechanisms.SupportsMechanism(MTX_GOOGLE_TOKEN) then
            args.Mechanism:=Xmpp.sasl.Mechanism.TMechanism.GetMechanismName(MTX_GOOGLE_TOKEN)
          else if f.Mechanisms.SupportsMechanism(MTDIGEST_MD5) then
            args.Mechanism:=Xmpp.sasl.Mechanism.TMechanism.GetMechanismName(MTDIGEST_MD5)
          else if f.Mechanisms.SupportsMechanism(MTPLAIN) then
            args.Mechanism:=Xmpp.sasl.Mechanism.TMechanism.GetMechanismName(MTPLAIN)
          else
            args.Mechanism:='';
        end
        else
          args.Mechanism:='';
      end;
      if args.Mechanism<>'' then
      begin
        _mechanism:=TSaslFactory.GetMechanism(args.Mechanism);
        _mechanism.Username:=TXmppClientConnection(_connection).UserName;
        _mechanism.Password:=TXmppClientConnection(_connection).Password;
        _mechanism.Server:=TXmppClientConnection(_connection).Server;
        _mechanism.Init(_connection);
      end
      else
        TXmppClientConnection(_connection).RequestLoginInfo;
    end
    else if not TXmppClientConnection(_connection).Binded then
    begin
      if f.SupportsBind then
      begin
        _connection.DoChangeXmppConnectionState(Binding);
        if (TXmppClientConnection(_connection).Resource='') then
          biq:=TBindIq.Create('set',TJID.Create(_connection.Server))
        else
          biq:=TBindIq.Create('set',tjid.Create(_connection.Server),TXmppClientConnection(_connection).Resource);
        TXmppClientConnection(_connection).IqGrabber.SendIq(biq,BindResult);
      end;
    end;
  end
  else if e.IsTagEqual(TChallenge) then
  begin
    if Assigned(_mechanism) and (not TXmppClientConnection(_connection).Authenticated) then
      _mechanism.Parse(e);
  end
  else if e.IsTagEqual(TSuccess) then
  begin
    if Assigned(FOnSaslEnd) then
      FOnSaslEnd(Self);
    _connection.DoChangeXmppConnectionState(Authenticated);
    FreeAndNil(_mechanism);
    TXmppClientConnection(_connection).ReSet();
  end
  else if e.IsTagEqual(TFailure) then
    TXmppClientConnection(_connection).FireOnAuthError(e);
end;

procedure TSaslHandler.SessionResult(sender: TObject; iq: TIQ; const data: pointer);
begin
  if iq.IqType='result' then
  begin
    _connection.DoChangeXmppConnectionState(SessionStarted);;
    TXmppClientConnection(_connection).RaiseOnLogin();
  end;
end;

end.

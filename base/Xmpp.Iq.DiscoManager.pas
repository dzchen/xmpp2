unit Xmpp.Iq.DiscoManager;

interface
uses
  XmppClientConnection,Xmpp.Client.IQ,Xmpp.iq.DiscoInfo,Xmpp.iq.DiscoItemsIq,Jid,XMPPEvent,Xmpp.iq.DiscoInfoIq,Element;
type
  TDiscoManager=class
  private
    _autoanswerdiscoinforequests:Boolean;
    _connection:TXmppClientConnection;
    procedure OnIq(sender:TObject;iq:TIQ);
    procedure ProcessDiscoInfo(iq:TIQ);

  public
    constructor Create(conn:TXmppClientConnection);
    property AutoAnswerDiscoInfoRequests:Boolean read _autoanswerdiscoinforequests write _autoanswerdiscoinforequests;

    procedure DiscoverInformation(tojid:TJID);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID);overload;
    procedure DiscoverInformation(tojid:TJID;cb:TIqCB);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID;cb:TIqCB);overload;
    procedure DiscoverInformation(tojid:TJID;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverInformation(tojid:TJID;node:string);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID;node:string);overload;
    procedure DiscoverInformation(tojid:TJID;node:string;cb:TIqCB);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID;node:string;cb:TIqCB);overload;
    procedure DiscoverInformation(tojid:TJID;node:string;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverInformation(tojid,fromjid:TJID;node:string;cb:TIqCB;const cbargs:Pointer);overload;

    procedure DiscoverItems(tojid:TJID);overload;
    procedure DiscoverItems(tojid,fromjid:TJID);overload;
    procedure DiscoverItems(tojid:TJID;cb:TIqCB);overload;
    procedure DiscoverItems(tojid,fromjid:TJID;cb:TIqCB);overload;
    procedure DiscoverItems(tojid:TJID;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverItems(tojid,fromjid:TJID;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverItems(tojid:TJID;node:string);overload;
    procedure DiscoverItems(tojid,fromjid:TJID;node:string);overload;
    procedure DiscoverItems(tojid:TJID;node:string;cb:TIqCB);overload;
    procedure DiscoverItems(tojid,fromjid:TJID;node:string;cb:TIqCB);overload;
    procedure DiscoverItems(tojid:TJID;node:string;cb:TIqCB;const cbargs:Pointer);overload;
    procedure DiscoverItems(tojid,fromjid:TJID;node:string;cb:TIqCB;const cbargs:Pointer);overload;

  end;

implementation


{ TDiscoManager }

constructor TDiscoManager.Create(conn:TXmppClientConnection);
begin
  _autoanswerdiscoinforequests:=true;
  _connection:=conn;
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID; cb: TIqCB;
  const cbargs:Pointer);
begin
  DiscoverInformation(tojid,nil,'',cb,cbargs);
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID; cb:TIqCB;const cbargs:Pointer);
begin
  DiscoverInformation(tojid,fromjid,'',cb,cbargs);
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID; node: string);
begin
  DiscoverInformation(tojid,nil,node,TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID; cb: TIqCB);
begin
  DiscoverInformation(tojid,fromjid,'',cb,(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID);
begin
  DiscoverInformation(tojid,nil,'',TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID);
begin
  DiscoverInformation(tojid,fromjid,'',TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID; cb: TIqCB);
begin
  DiscoverInformation(tojid,nil,'',cb,(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID; node: string; cb:TIqCB;const cbargs:Pointer);
begin
  DiscoverInformation(tojid,nil,node,cb,cbargs);
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID; node: string;
  cb:TIqCB;const cbargs:Pointer);
var
  discoiq:TDiscoInfoIq;
begin
  discoiq:=TDiscoInfoIq.Create('get');
  discoiq.ToJid:=tojid;
  if fromjid<>nil then
    discoiq.FromJid:=fromjid;
  if node<>'' then
    discoiq.Query.Node:=node;
  _connection.IqGrabber.SendIq(discoiq,cb,cbargs);
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID; node: string;
  cb: TIqCB);
begin
  DiscoverInformation(tojid,fromjid,node,cb,(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid, fromjid: TJID; node: string);
begin
  DiscoverInformation(tojid,fromjid,node,TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverInformation(tojid: TJID; node: string;
  cb: TIqCB);
begin
  DiscoverInformation(tojid,nil,node,cb,(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID; cb:TIqCB;const cbargs:Pointer);
begin
  DiscoverItems(tojid,nil,'',cb,cbargs);
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID; cb:TIqCB;const cbargs:Pointer);
begin
  DiscoverItems(tojid,fromjid,'',cb,cbargs);
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID; node: string);
begin
  DiscoverItems(tojid,nil,node,TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID; cb: TIqCB);
begin
  DiscoverItems(tojid,fromjid,'',cb,(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID);
begin
  DiscoverItems(tojid,nil,'',TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID);
begin
  DiscoverItems(tojid,fromjid,'',TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID; cb: TIqCB);
begin
  DiscoverItems(tojid,nil,'',cb,(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID; node: string; cb:TIqCB;const cbargs:Pointer);
begin
  DiscoverItems(tojid,nil,node,cb,cbargs);
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID; node: string;
  cb: TIqCB; const cbargs:Pointer);
var
  discoiq:TDiscoItemsIq;
begin
  discoiq:=TDiscoItemsIq.Create('get');
  discoiq.ToJid:=tojid;
  if fromjid<>nil then
    discoiq.FromJid:=fromjid;
  if node<>'' then
    discoiq.Query.Node:=node;
  _connection.IqGrabber.SendIq(discoiq,cb,cbargs);
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID; node: string;
  cb: TIqCB);
begin
  DiscoverItems(tojid,fromjid,node,cb,TElement(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid, fromjid: TJID; node: string);
begin
  DiscoverItems(tojid,fromjid,node,TIqCB(nil),(nil));
end;

procedure TDiscoManager.DiscoverItems(tojid: TJID; node: string; cb: TIqCB);
begin
  DiscoverItems(tojid,nil,node,cb,(nil));
end;

procedure TDiscoManager.OnIq(sender: TObject; iq: TIQ);
begin
  if _autoanswerdiscoinforequests and (iq.Query.IsTagEqual(TDiscoInfo)) and (iq.IqType='get') then
    ProcessDiscoInfo(iq);
end;

procedure TDiscoManager.ProcessDiscoInfo(iq: TIQ);
var
  diiq:TIQ;
begin
  diiq:=tiq.Create;
  diiq.ToJid:=iq.FromJid;
  diiq.Id:=iq.Id;
  diiq.IqType:='result';
  diiq.Query:=_connection.DiscoInfo;
  _connection.Send(diiq);

end;

end.

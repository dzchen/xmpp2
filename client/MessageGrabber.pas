unit MessageGrabber;

interface
uses
  XMPPEvent,PacketGrabber,Jid,XmppConnection,xmpp.client.Message,JidComparer;
type
  TMessageGrabber=class(TPacketGrabber)
  public
    constructor Create();overload;
    procedure Add(jid:TJid;cb:Tmessagecb;const cbarg:Pointer);overload;
    procedure Add(jid:TJid;comparer:TBareJidComparer;cb:Tmessagecb;const cbarg:Pointer);overload;
    procedure Remove(jid:TJID);
    procedure OnMessage(sender:TObject;msg:TMessage);

  end;

implementation
uses
  XmppClientConnection;
{ TMessageGrabber }

procedure TMessageGrabber.Add(jid: TJid; cb: Tmessagecb; const cbarg:Pointer);
var
  td:TMethod;
  s:string;
  th:TrackerData;
begin
  _lock.Acquire;
  if _grabbing.ContainsKey(jid.tostring) then
    exit;
  _lock.Release;
  td:=TMethod(cb);
  th.cb:=td;
  th.data:=cbarg;
  th.comparer:=TBareJidComparer.create;
  s:=jid.ToString;
  _lock.Acquire;
  if _grabbing.ContainsKey(s) then
      _grabbing[s]:=th
    else
      _grabbing.Add(s,th);
  _lock.Release;
end;

procedure TMessageGrabber.Add(jid: TJid; comparer: TBareJidComparer;
  cb: Tmessagecb; const cbarg:Pointer);
var
  td:TMethod;
  s:string;
  th:TrackerData;
begin
  _lock.Acquire;
  if _grabbing.ContainsKey(jid.tostring) then
    exit;
  _lock.Release;
  td:=TMethod(cb);
  th.cb:=td;
  th.data:=cbarg;
  th.comparer:=comparer;
  s:=jid.ToString;
  _lock.Acquire;
  if _grabbing.ContainsKey(s) then
      _grabbing[s]:=th
    else
      _grabbing.Add(s,th);
  _lock.Release;
end;

constructor TMessageGrabber.Create();
begin
  inherited Create();
end;

procedure TMessageGrabber.OnMessage(sender: TObject; msg: TMessage);
var
  key:string;
  th:TrackerData;
  td:TMethod;
begin
  if msg=nil then
    exit;
  _lock.Acquire;
  for key in _grabbing.Keys do
  begin
    th:=_grabbing[key];
    if th.comparer.Compare(tjid.Create(key),msg.FromJid)=0 then
    begin
      td:=th.cb;
      if (td.Data<>nil) or (td.Code<>nil) then
      begin
        Tmessagecb(td)(self,msg,th.Data);
      end;
    end;
  end;
 
  _lock.Release;

end;

procedure TMessageGrabber.Remove(jid: TJID);
var
  s:string;
begin
  s:=jid.ToString;
  _lock.Acquire;
  if _grabbing.ContainsKey(s) then
    _grabbing.Remove(s);
  _lock.Release;
end;

end.

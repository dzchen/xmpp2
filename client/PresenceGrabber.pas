unit PresenceGrabber;

interface
uses
  PacketGrabber,XmppConnection,Jid,XMPPEvent,Xmpp.Client.Presence,JidComparer;
type
  TPresenceGrabber=class(TPacketGrabber)
  public
   procedure OnPresence(sender:TObject;pres:TPresence);
    constructor Create(conn:TXmppConnection);overload;
    procedure Add(jid:Tjid;cb:TPresenceHandler;const cbArg:Pointer);overload;
    procedure Add(jid:Tjid;comparer:TBareJidComparer;cb:TPresenceHandler;const cbArg:Pointer);overload;
    procedure Remove(jid:TJID);

  end;

implementation
uses
  XmppClientConnection;

{ TPresenceGrabber }

procedure TPresenceGrabber.Add(jid: Tjid; cb: TPresenceHandler; const cbArg: Pointer);
var
  td:TMethod;
  th:TrackerData;
  s:string;
begin
  _lock.Acquire;
  if _grabbing.ContainsKey(jid.ToString) then
    exit;
  _lock.Release;
    td:=tmethod(cb);
    th.cb:=td;
    th.data:=cbarg;
    th.comparer:=TBareJidComparer.Create;
    s:=jid.ToString;
    _lock.Acquire;
      _grabbing.Add(s,th);
  _lock.Release;
end;

procedure TPresenceGrabber.Add(jid: Tjid; comparer: TBareJidComparer;
  cb: TPresenceHandler; const cbArg: Pointer);
var
  td:TMethod;
  th:TrackerData;
  s:string;
begin
  _lock.Acquire;
  if _grabbing.ContainsKey(jid.ToString) then
    exit;
  _lock.Release;
    td:=tmethod(cb);
    th.cb:=td;
    th.data:=cbarg;
    th.comparer:=comparer;
    s:=jid.ToString;
    _lock.Acquire;
      _grabbing.Add(s,th);
  _lock.Release;
end;

constructor TPresenceGrabber.Create(conn: TXmppConnection);
begin
  inherited Create();
end;

procedure TPresenceGrabber.OnPresence(sender: TObject; pres: TPresence);
var
  s:string;
  th:TrackerData;
  td:TMethod;
begin
  if pres<>nil then
  begin
    _lock.Acquire;
    for s in _grabbing.Keys do
    begin
        th:=_grabbing[s];
        if th.comparer.Compare(tjid.Create(s),pres.FromJid)=0 then
        begin
          td:=th.cb;
          if (td.Data<>nil) or (td.Code<>nil) then
          begin
            Tpresencecb(td)(self,pres,th.Data);
          end;
        end;
    end;
   
    _lock.Release;
  end;
end;

procedure TPresenceGrabber.Remove(jid: TJID);
begin
  _lock.Acquire;
  if _grabbing.ContainsKey(jid.ToString) then
    _grabbing.Remove(jid.ToString);
  _lock.Release;
end;

end.

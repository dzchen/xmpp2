unit IqGrabber;

interface
uses
  PacketGrabber,xmpp.client.IQ,XMPPEvent,XmppConnection,Element;
type
  TIqGrabber=class(TPacketGrabber)
  private
    synchronousresponse:TIQ;
    _synchronoustimeout:integer;
    foniq:TIqHandler;
    _connection:TXmppConnection;
  public
    constructor Create(conn:TXmppConnection);overload;
    property SynchronousTimeout:Integer read _synchronoustimeout write _synchronoustimeout;
    property FireOnIq:TIqHandler read foniq write foniq;
    procedure SendIq(iq:TIQ;cb:TIqCB);overload;
    procedure SendIq(iq:TIQ;cb:TIqCB;const cbarg:Pointer);overload;
    function SendIq(iq:TIQ;timeout:Integer):TIQ;overload;
    function SendIq(iq:TIQ):TIQ;overload;
    procedure SynchronousIqResult(sender:TObject;iq:TIQ;data:TObject);
    procedure OnIq(sender:TObject;iq:TIQ);
  end;

implementation
uses
  XmppClientConnection;

{ TIqGrabber }

constructor TIqGrabber.Create(conn:TXmppConnection);

begin
  _synchronoustimeout:=5000;
  inherited Create();
  _connection:=conn;
end;

procedure TIqGrabber.OnIq(sender: TObject; iq: TIQ);
var
  id:string;
  th:TrackerData;
  td:TMethod;
begin
  if iq<>nil then
  begin
    if (iq.IqType<>'error') and (iq.IqType<>'result') then
      exit;
    id:=iq.Id;
    if id<>'' then
    begin
      _lock.Acquire;
      if _grabbing.ContainsKey(id) then
      begin
        td:=_grabbing[id].cb;
        //th.data:=_grabbing[id].data;
         _grabbing.Remove(id);
        if (td.Data<>nil) or (td.Code<>nil) then
        begin
          TIqCB(td)(self,iq,th.Data);
        end;
      end;
      _lock.Release;


      //th.cb(self,iq,'');
    end;
  end;
end;

procedure TIqGrabber.SendIq(iq: TIQ; cb: TIqCB; const cbarg:Pointer);
var
  td:TMethod;
  s:string;
  th:TrackerData;
begin
  if Assigned(cb) then
  begin
    th.data:=cbarg;
    td:=Tmethod(cb);
    th.cb:=td;
    s:=iq.id;
    if _grabbing.ContainsKey(s) then
      _grabbing[s]:=th
    else
      _grabbing.Add(s,th);
  end;
  _connection.Send(iq);
end;

procedure TIqGrabber.SendIq(iq: TIQ; cb: TIqCB);
begin
  SendIq(iq,cb,nil);
end;

function TIqGrabber.SendIq(iq: TIQ; timeout: Integer): TIQ;
begin
  synchronousresponse:=nil;
  //SendIq(iq,SynchronousIqResult,False);
  if _grabbing.ContainsKey(iq.Id) then
    _grabbing.Remove(iq.Id);
  Result:=synchronousresponse;
end;

function TIqGrabber.SendIq(iq: TIQ): TIQ;
begin
  Result:=SendIq(iq,_synchronoustimeout);
end;

procedure TIqGrabber.SynchronousIqResult(sender: TObject; iq: TIQ;
  data: TObject);
begin
  synchronousresponse:=iq;

end;

end.


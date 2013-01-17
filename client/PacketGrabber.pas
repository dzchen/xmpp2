unit PacketGrabber;

interface
uses
  Generics.Collections,xmpp.client.iq,SyncObjs,Element,JidComparer,xmltag;
type
  TIqHandler = procedure (sender: TObject; iq:txmltag;cbarg:Pointer) of object;
  TrackerData=record
    cb:TMethod;
    data:Pointer;
    comparer:TBareJidComparer;
  end;
  TPacketGrabber=class
  protected
    _lock:TCriticalSection;
    _grabbing:TDictionary<string,TrackerData>;
  public
    constructor Create;
    destructor Destory;
    procedure Clear;
    procedure Remove(id:string);
  end;

implementation

{ TPacketGrabber }

procedure TPacketGrabber.Clear;
begin
  _lock.Acquire;
  _grabbing.Clear;
  _lock.Release;
end;

constructor TPacketGrabber.Create;
begin
  _lock:=TCriticalSection.Create;
   _grabbing:=TDictionary<string,TrackerData>.Create;
end;

destructor TPacketGrabber.Destory;
begin
  _grabbing.Clear;
  _grabbing.Free;
  _lock.Free;
end;

procedure TPacketGrabber.Remove(id: string);
begin
  if _grabbing.ContainsKey(id) then
    _grabbing.Remove(id);
end;


end.

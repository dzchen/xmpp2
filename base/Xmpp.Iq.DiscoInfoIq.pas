unit Xmpp.Iq.DiscoInfoIq;

interface
uses
  xmpp.client.iq,Xmpp.iq.DiscoInfo;
type
  TDiscoInfoIq=class(TIQ)
  private
    _discoinfo:TDiscoinfo;
  public
    constructor Create;overload;override;
    constructor Create(iqtype:string);overload;
    property Query:TDiscoInfo read _discoinfo;
  end;

implementation

{ TDiscoInfoIq }

constructor TDiscoInfoIq.Create;
begin
  inherited Create;
  _discoinfo:=TDiscoInfo.Create;
  FSetQuery(_discoinfo);
  GenerateId;
end;

constructor TDiscoInfoIq.Create(iqtype: string);
begin
  self.Create;
  self.IqType:=iqtype;
end;

end.

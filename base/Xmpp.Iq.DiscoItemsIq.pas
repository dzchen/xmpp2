unit Xmpp.Iq.DiscoItemsIq;

interface
uses
  Xmpp.Client.IQ,Xmpp.iq.DiscoItems;
type
  TDiscoItemsIq=class(TIQ)
  private
    _discoitems:TDiscoItems;
  public
    constructor Create;overload;override;
    constructor Create(iqtype:string);overload;
    property Query:TDiscoItems read _discoitems;
  end;

implementation

{ TDiscoItemsIq }

constructor TDiscoItemsIq.Create;
begin
  inherited Create;
  _discoitems:=TDiscoItems.Create;
  FSetQuery(_discoitems);
  GenerateId;
end;

constructor TDiscoItemsIq.Create(iqtype: string);
begin
  self.Create;
  self.IqType:=iqtype;
end;

end.

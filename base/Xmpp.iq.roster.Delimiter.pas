unit Xmpp.iq.roster.Delimiter;

interface
uses
  Element,XmppUri;
type
  TDelimiter=class(TElement)
  const
    TagName='roster';
  public
    constructor Create;overload;override;
    constructor Create(delimiter:string);overload;
    class function GetConstTagName():string;override;
  end;

implementation

{ TDelimiter }

constructor TDelimiter.Create;
begin
  inherited Create;
  Name:='roster';
  Namespace:=XMLNS_ROSTER_DELIMITER;
end;

constructor TDelimiter.Create(delimiter: string);
begin
  Self.Create;
  self.value:=delimiter;
end;

class function TDelimiter.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_ROSTER_DELIMITER;
end;

end.

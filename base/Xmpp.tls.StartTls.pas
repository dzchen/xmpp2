unit Xmpp.tls.StartTls;

interface
uses
  Element,XmppUri;
type
  TStartTls=class(TElement)
  const
    TagName='starttls';
  private
    function FGetRequired:Boolean;
    procedure FSetRequired(value:Boolean);
  public
    constructor Create;override;
    property Required:Boolean read FGetRequired write FSetRequired;
    class function GetConstTagName():string;override;
  end;
  TProceed=class(TElement)
  const
  TagName='proceed';
  public
    constructor Create;override;
    class function GetConstTagName():string;override;
  end;
implementation

{ TStartTls }

constructor TStartTls.Create;
begin
  inherited Create;
  Name:=TagName;
  Namespace:=XMLNS_TLS;
end;

function TStartTls.FGetRequired: Boolean;
begin
  Result:=HasTag('required');
end;

procedure TStartTls.FSetRequired(value: Boolean);
begin
  if value=False then
  begin
    RemoveTag('required');

  end
  else
    if not HasTag('required') then
      AddTag('required');
end;

class function TStartTls.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_TLS;
end;

{ TProceed }

constructor TProceed.Create;
begin
  inherited;
  Name:='proceed';
  Namespace:=XMLNS_TLS;
end;

class function TProceed.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_TLS;
end;

end.

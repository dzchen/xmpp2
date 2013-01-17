unit Xmpp.stream.Features;

interface
uses
  Element,XmppUri,Xmpp.Iq.BindIq,xmpp.stream.feature.compression.Compression,xmpp.stream.feature.Register,xmpp.tls.StartTls
  ,xmpp.sasl.Mechanisms;
type
  TFeatures=class(TElement)
  const
    TagName='features';
    TagNamespace=XMLNS_STREAM;
  private
    function FGetStartTls:TStartTls;
    procedure FSetStartTls(value:TStartTls);
    function FGetBind:TBind;
    procedure FSetBind(value:TBind);
    function FGetCompression:TCompression;
    procedure FSetCompression(value:TCompression);
    function FGetRegister:TRegister;
    procedure FSetRegister(value:TRegister);
    function FGetMechanisms:TMechanisms;
    procedure FSetMechanisms(value:TMechanisms);
    function FGetSupportsBind:Boolean;
    function FGetSupportsStartTls:Boolean;
    function FGetSupportsCompression:Boolean;
    function FGetSupportsRegistration:Boolean;
  public
    constructor Create;override;
    property StartTls:TStartTls read FGetStartTls write FSetStartTls;
    property Bind:TBind read FGetBind write FSetBind;
    property Compression:TCompression read FGetCompression write FSetCompression;
    property FeaturesRegister:TRegister read FGetRegister write FSetRegister;
    property Mechanisms:TMechanisms read FGetMechanisms write FSetMechanisms;
    property SupportsBind:Boolean read FGetSupportsBind;
    property SupportsStartTls:Boolean read FGetSupportsStartTls;
    property SupportsCompression:Boolean read FGetSupportsCompression;
    property SupportsRegistration:Boolean read FGetSupportsRegistration;
    class function GetConstTagName():string;override;
  end;
implementation

{ TFeatures }

constructor TFeatures.Create;
begin
  inherited Create;
  Name:=TagName;
  Namespace:=TagNamespace;
end;

function TFeatures.FGetBind: TBind;
begin
  Result:=TBind(GetFirstTag(TBind.TagName));
end;

function TFeatures.FGetCompression: TCompression;
begin
  Result:=TCompression(GetFirstTag(TCompression.TagName));
end;

function TFeatures.FGetMechanisms: TMechanisms;
begin
  Result:=TMechanisms(GetFirstTag(TMechanisms.TagName));
end;

function TFeatures.FGetRegister: TRegister;
begin
  Result:=TRegister(GetFirstTag(TRegister.TagName));
end;

function TFeatures.FGetStartTls: TStartTls;
begin
  Result:=TStartTls(GetFirstTag(TStartTls.TagName));
end;

function TFeatures.FGetSupportsBind: Boolean;
begin
  result:=Bind<>nil;

end;

function TFeatures.FGetSupportsCompression: Boolean;
begin
  result:=Compression<>nil;
end;

function TFeatures.FGetSupportsRegistration: Boolean;
begin
  result:=FeaturesRegister<>nil;
end;

function TFeatures.FGetSupportsStartTls: Boolean;
begin
  result:=StartTls<>nil;
end;

procedure TFeatures.FSetBind(value: TBind);
begin
  RemoveTag(TBind.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TFeatures.FSetCompression(value: TCompression);
begin
  RemoveTag(TCompression.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TFeatures.FSetMechanisms(value: TMechanisms);
begin
  RemoveTag(TMechanisms.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TFeatures.FSetRegister(value: TRegister);
begin
  RemoveTag(TRegister.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TFeatures.FSetStartTls(value: TStartTls);
begin
  RemoveTag(TStartTls.TagName);
  if value<>nil then
    AddTag(value);
end;

class function TFeatures.GetConstTagName: string;
begin
Result:=TagName+'-';
end;

end.

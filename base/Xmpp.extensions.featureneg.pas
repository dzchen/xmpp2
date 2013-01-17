unit Xmpp.extensions.featureneg;

interface
uses
  XmppUri,Element,Xmpp.x.Data,Xmpp.Client.iq;
type
  TFeatureNeg=class(TElement)
  const
  TagName='feature';
  private
    function FGetData:TData;
    procedure FSetData(value:TData);
  public
    constructor Create;override;
    property Data:TData read FGetData write FSetData;
    class function GetConstTagName():string;override;
  end;
  TFeatureNegIq=class(TIQ)
  private
    _featureneg:TFeatureNeg;
  public
    constructor Create;overload;override;
    constructor Create(iqtype:string);overload;
    property FeatureNeg:TFeatureNeg read _featureneg;
  end;

implementation

{ TFeatureNeg }

constructor TFeatureNeg.Create;
begin
  inherited;
  Name:='feature';
  Namespace:=XMLNS_FEATURE_NEG;
end;

function TFeatureNeg.FGetData: TData;
begin
  Result:=TData(GetFirstTag(TData.TagName));
end;

procedure TFeatureNeg.FSetData(value: TData);
begin
  if HasTag(TData.TagName) then
    RemoveTag(Tdata.TagName);
  AddTag(value);
end;

class function TFeatureNeg.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_FEATURE_NEG;
end;

{ TFeatureNegIq }

constructor TFeatureNegIq.Create;
begin
  inherited;
  _featureneg:=TFeatureNeg.Create;
  AddTag(_featureneg);
  GenerateId;
end;

constructor TFeatureNegIq.Create(iqtype: string);
begin
  Self.Create;
  self.IqType:=iqtype;
end;

end.

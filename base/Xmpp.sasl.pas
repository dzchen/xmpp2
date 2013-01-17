unit Xmpp.sasl;

interface
uses
  Element,XmppUri,XMPPConst,xmpp.sasl.Mechanism;
type
  TChallenge=class(TElement)
  const
    TagName='challenge';
  public
    constructor Create;override;
    class function GetConstTagName: string;override;
  end;
  TFailure=class(TElement)
  const
    TagName='failure';
  private
    function FGetFailureCondition:TFailureCondition;
    procedure FSetFailureCondition(value:TFailureCondition);
  public
    constructor Create;override;
    constructor Create(cond:TFailureCondition);overload;
    property Condition:TFailureCondition read FGetFailureCondition write FSetFailureCondition;
    class function GetConstTagName: string;override;
  end;
  TSuccess=class(TElement)
  const
    TagName='success';
  public
    constructor Create;override;
    class function GetConstTagName: string;override;
  end;
  TResponse=class(TElement)
  const
    TagName='response';
  public
    constructor Create;override;
    constructor Create(txt:string);overload;
    class function GetConstTagName: string;override;
  end;
  TAbort=class(TElement)
  const
    TagName='abort';
  public
    constructor Create;override;
    class function GetConstTagName: string;override;
  end;
  TAuth=class(TElement)
  const
    TagName='auth';
  private
    function FGetMechanismType:TMechanismType;
    procedure FSetMechanismType(value:TMechanismType);
  public
    constructor Create;override;
    constructor Create(tp:TMechanismType);overload;
    constructor Create(tp:TMechanismType;txt:string);overload;
    property MechanismType:TMechanismType read FGetMechanismType write FSetMechanismType;
    class function GetConstTagName: string;override;
  end;
implementation

{ TChallenge }

constructor TChallenge.Create;
begin
  inherited;
  Self.Name:=TagName;
  self.Namespace:=xmlns_sasl;
end;

class function TChallenge.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

{ TFailure }

constructor TFailure.Create;
begin
  inherited;
  self.Name:=TagName;
  self.Namespace:=XMLNS_SASL;
end;

constructor TFailure.Create(cond: TFailureCondition);
begin
  self.Create;
  Condition:=cond;
end;

function TFailure.FGetFailureCondition: TFailureCondition;
begin
  if HasTag('aborted') then
    result:=fcaborted
  else if (HasTag('incorrect-encoding')) then
                    result:=fcincorrect_encoding
                else if (HasTag('invalid-authzid'))  then
                    result:=fcinvalid_authzid
                else if (HasTag('invalid-mechanism')) then
                    result:=fcinvalid_mechanism
                else if (HasTag('mechanism-too-weak')) then
                    result:=fcmechanism_too_weak
                else if (HasTag('not-authorized')) then
                    result:=fcnot_authorized
                else if (HasTag('temporary-auth-failure')) then
                    result:=fctemporary_auth_failure
                else
                    result:=fcUnknownCondition;
end;

procedure TFailure.FSetFailureCondition(value: TFailureCondition);
begin
  if value=fcaborted then
    AddTag('aborted')
  else if (value = fcincorrect_encoding)  then
                    AddTag('incorrect-encoding')
                else if (value = fcinvalid_authzid)   then
                    AddTag('invalid-authzid')
                else if (value = fcinvalid_mechanism)  then
                    AddTag('invalid-mechanism')
                else if (value = fcmechanism_too_weak)  then
                    AddTag('mechanism-too-weak')
                else if (value = fcnot_authorized) then
                    AddTag('not-authorized')
                else if (value = fctemporary_auth_failure)  then
                    AddTag('temporary-auth-failure');
end;

class function TFailure.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

{ TSuccess }

constructor TSuccess.Create;
begin
  inherited;
  self.Name:=TagName;
  self.Namespace:=XMLNS_SASL;
end;

class function TSuccess.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

{ TResponse }

constructor TResponse.Create;
begin
  inherited;
  Self.Name:=TagName;
  self.Namespace:=XMLNS_SASL;
end;

constructor TResponse.Create(txt: string);
begin
  Self.Create;
  self.TextBase64:=txt;
end;

class function TResponse.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

{ TAuth }

constructor TAuth.Create;
begin
  inherited;
  self.Name:=TagName;
  self.Namespace:=XMLNS_SASL;
end;

constructor TAuth.Create(tp: TMechanismType);
begin
  self.Create;
  MechanismType:=tp;
end;

constructor TAuth.Create(tp: TMechanismType; txt: string);
begin
  self.Create;
  MechanismType:=tp;
  Self.Value:=txt;
end;

function TAuth.FGetMechanismType: TMechanismType;
begin
  result:=tmechanism.GetMechanismType(GetAttribute('mechanism'));
end;

procedure TAuth.FSetMechanismType(value: TMechanismType);
begin
  SetAttribute('mechanism',TMechanism.GetMechanismName(value));
end;

class function TAuth.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

{ TAbort }

constructor TAbort.Create;
begin
  inherited;
  self.Name:=TagName;
  self.NameSpace:=XMLNS_SASL;
end;

class function TAbort.GetConstTagName: string;
begin
  Result:=TagName+'-'+xmlns_sasl;
end;

end.

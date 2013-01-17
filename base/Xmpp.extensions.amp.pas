unit Xmpp.extensions.amp;

interface
uses
  Xmpp.DirectionalElement,XmppUri,Element,Xmpp.extensions.Rule,Generics.Collections,SysUtils,System.Classes;
type
  TAmp=class(TDirectionalElement)
  const
  TagName='amp';
  private
    function FGetStatus:string;
    procedure FSetStatus(val:string);
    function FGetPerHop:Boolean;
    procedure FSetPerHop(val:Boolean);
  public
    constructor Create;override;
    property Status:string read FGetStatus write FSetStatus;
    property PerHop:Boolean read FGetPerHop write FSetPerHop;
    procedure AddRule(rule:TRule);overload;
    function AddRule():TRule;overload;
    function GetRules():TList;
    class function GetConstTagName():string;override;
  end;

implementation

{ TAmp }

function TAmp.AddRule: TRule;
var
  rule:TRule;
begin
  rule:=TRule.Create;
  AddTag(rule);
  Result:=rule;
end;

procedure TAmp.AddRule(rule: TRule);
begin
  AddTag(rule);
end;

constructor TAmp.Create;
begin
  inherited;
  Name:='amp';
  Namespace:=XMLNS_AMP;
end;

function TAmp.FGetPerHop: Boolean;
begin
  if lowercase(GetAttribute('per-hop'))='true' then
    Result:=true
  else
    Result:=False;
end;

function TAmp.FGetStatus: string;
begin
  Result:=GetAttribute('status');
end;

procedure TAmp.FSetPerHop(val: Boolean);
begin
  if(val)then
  SetAttribute('per-hop','true')
  else
  SetAttribute('per-hop','false')
end;

procedure TAmp.FSetStatus(val: string);
begin
  SetAttribute('status',val);
end;

class function TAmp.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_AMP;
end;

function TAmp.GetRules: TList;
begin
  Result:=SelectElements(trule.TagName);

end;

end.

unit Xmpp.Iq.AgentIq;

interface
uses
  Element,XmppUri,Jid,Classes,xmpp.client.iq;
type
  TAgent=class(TElement)
  const
  TagName='agent';
  private
    function FGetJid:TJID;
    procedure FSetJid(value:TJID);
    function FGetAgentName:string;
    procedure FSetAgentName(value:string);
    function FGetService:string;
    procedure FSetService(value:string);
    function FGetDescription:string;
    procedure FSetDescription(value:string);
    function FGetCanRegister:Boolean;
    procedure FSetCanRegister(value:Boolean);
    function FGetCanSearch:Boolean;
    procedure FSetCanSearch(value:Boolean);
    function FGetIsTransport:Boolean;
    procedure FSetIsTransport(value:Boolean);
    function FGetIsGroupchat:Boolean;
    procedure FSetIsGroupchat(value:Boolean);
  public
    constructor Create();override;

    property Jid:TJID read FGetJid write FSetJid;
    property AgentName:string read FGetAgentName write FSetAgentName;
    property Service:string read FGetService write FSetService;
    property Description:string read FGetDescription write FSetDescription;
    property CanRegister:Boolean read FGetCanRegister write FSetCanRegister;
    property CanSearch:Boolean read FGetCanSearch write FSetCanSearch;
    property IsTransport:Boolean read FGetIsTransport write FSetIsTransport;
    property IsGroupchat:Boolean read FGetIsGroupchat write FSetIsGroupchat;
    class function GetConstTagName():string;override;
  end;
  TAgents=class(TElement)
  const
    TagName='query';
  public
    constructor Create();override;
    procedure GetAgents(al:TList);
    class function GetConstTagName():string;override;
  end;
  TAgentsIq=class(TIQ)
  private
    _agents:Tagents;
  public
    constructor Create;overload;override;
    constructor Create(iqtype:string);overload;
    constructor Create(iqtype:string;tojid:TJID);overload;
    constructor Create(iqtype:string;tojid,fromjid:TJID);overload;
    property Query:TAgents read _agents;
  end;

implementation

{ TAgent }

constructor TAgent.Create();
begin
  inherited Create();
  Name:='agent';
  Namespace:=XMLNS_IQ_AGENTS;
end;



function TAgent.FGetAgentName: string;
begin
  Result:=GetTag('name');
end;

function TAgent.FGetCanRegister: Boolean;
begin
  Result:=HasTag('register');
end;

function TAgent.FGetCanSearch: Boolean;
begin
  Result:=HasTag('search');
end;

function TAgent.FGetDescription: string;
begin
  Result:=GetTag('description');
end;

function TAgent.FGetIsGroupchat: Boolean;
begin
  Result:=HasTag('groupchat');
end;

function TAgent.FGetIsTransport: Boolean;
begin
  Result:=HasTag('transport');
end;

function TAgent.FGetJid: TJID;
begin
  Result:=TJID.Create(GetAttribute('jid'));
end;

function TAgent.FGetService: string;
begin
  Result:=GetTag('service');
end;

procedure TAgent.FSetAgentName(value: string);
begin
  settag('name',value);
end;

procedure TAgent.FSetCanRegister(value: Boolean);
begin
  if Value then
    AddTag('register')
  else
    RemoveTag('register');
end;

procedure TAgent.FSetCanSearch(value: Boolean);
begin
  if Value then
    AddTag('search')
  else
    RemoveTag('search');
end;

procedure TAgent.FSetDescription(value: string);
begin
  settag('description',value);
end;

procedure TAgent.FSetIsGroupchat(value: Boolean);
begin
  if Value then
    AddTag('groupchat')
  else
    RemoveTag('groupchat');
end;

procedure TAgent.FSetIsTransport(value: Boolean);
begin
  if Value then
    AddTag('transport')
  else
    RemoveTag('transport');
end;

procedure TAgent.FSetJid(value: TJID);
begin
  SetAttribute('jid',value.ToString);
end;

procedure TAgent.FSetService(value: string);
begin
  settag('service',value);
end;

class function TAgent.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_IQ_AGENTS;
end;

{ TAgents }

constructor TAgents.Create;
begin
  inherited Create();
  Name:='query';
  Namespace:=XMLNS_IQ_AGENTS;
end;

procedure TAgents.GetAgents(al: TList);
begin
  al:=SelectElements('agent');
end;

class function TAgents.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_IQ_AGENTS;
end;

{ TAgents }

constructor TAgentsIq.Create(iqtype: string);
begin
  self.Create;
  Self.IqType:=iqtype;
end;

constructor TAgentsIq.Create;
begin
  inherited create;
  _agents:=TAgents.Create;
  FSetQuery(_agents);
  GenerateId;
end;

constructor TAgentsIq.Create(iqtype: string; tojid, fromjid: TJID);
begin
  Self.Create(iqtype);
  self.ToJid:=tojid;
  self.FromJid:=fromjid;
end;

constructor TAgentsIq.Create(iqtype: string; tojid: TJID);
begin
  Self.Create(iqtype);
  self.ToJid:=tojid;
end;

end.

unit Xmpp.Client.IQ;

interface
uses
  xmpp.Stanza,jid,Element,xmpp.client.error,xmpp.iq.vcard,XmppUri,XMPPConst;
const
  IqType:array[0..3] of string=('get',
		'set',
		'result',
		'error');
type
  TIQTYPE=(iq_get,iq_set,iq_result,iq_error);
  TIQ=class(TStanza)
  const
    TagName='iq';
  private
    procedure FSetIqType(value:string);
    function FGetIqType:string;
    function FGetQuery:TElement;
    procedure FSetError(value:TError);
    function FGetError:TError;
    procedure FSetVcard(value:TVcard);
    function FGetVcard:TVcard;
    procedure FSetBind(value:TElement);
    function FGetBind:TElement;
    procedure FSetSession(value:TElement);
    function FGetSession:TElement;
  protected
    procedure FSetQuery(value:TElement);
  public
    constructor Create();override;
    constructor Create(iqtype:string);overload;
    constructor Create(fromjid:TJID;tojid:TJID);overload;
    constructor Create(iqtype:string;fromjid:TJID;tojid:TJID);overload;
    property IqType: string read FGetIqType write FSetIqType;
    property Query:TElement read FGetQuery write FSetQuery;
    property Error:TError read FGetError write FSetError;
    property Vcard:TVcard read FGetVcard write FSetVcard;
    property Bind:TElement read FGetBind write FSetBind;
    property Session:TElement read FGetSession write FSetSession;
    class function GetConstTagName():string;override;
  end;
implementation
uses
  xmpp.Iq.bindiq,Xmpp.Iq.SessionIq;

{ TIQ }

constructor TIQ.Create(fromjid, tojid: TJID);
begin
  Self.Create();
  self.FromJid:=fromjid;
  self.ToJid:=tojid;
end;

constructor TIQ.Create(iqtype: string);
begin
  self.Create();
  self.IqType:=iqtype;
end;

constructor TIQ.Create();
begin
  inherited Create();
  Name:=TagName;
  Namespace:=XMLNS_CLIENT;
end;

constructor TIQ.Create(iqtype: string; fromjid,
  tojid: TJID);
begin
  Self.Create();
  self.FromJid:=fromjid;
  self.ToJid:=tojid;
  self.IqType:=iqtype;
end;

function TIQ.FGetBind: TElement;
begin
  Result:=TBind(getfirsttag('bind'));
end;

function TIQ.FGetError: TError;
begin
  Result:=TError(getfirsttag('error'));
end;

function TIQ.FGetIqType: string;
begin
  Result:=GetAttribute('type');
end;

function TIQ.FGetQuery: TElement;
begin
  Result:=TElement(getfirsttag('query'));
end;

function TIQ.FGetSession: TElement;
begin
  Result:=TSession(getfirsttag('session'));
end;

function TIQ.FGetVcard: TVcard;
begin
  Result:=TVcard(getfirsttag('vCard'));
end;

procedure TIQ.FSetBind(value: TElement);
begin
  RemoveTag('bind');
  if(value<>nil)then
    AddTag(value);
end;

procedure TIQ.FSetError(value: TError);
begin
  RemoveTag('error');
  if(value<>nil)then
    AddTag(value);
end;

procedure TIQ.FSetIqType(value: string);
begin
  SetAttribute('type',value);
end;

procedure TIQ.FSetQuery(value: TElement);
begin
  RemoveTag('query');
  if(value<>nil)then
    AddTag(value);
end;

procedure TIQ.FSetSession(value: TElement);
begin
  RemoveTag('session');
  if(value<>nil)then
    AddTag(value);
end;

procedure TIQ.FSetVcard(value: TVcard);
begin
  RemoveTag('vCard');
  if(value<>nil)then
    AddTag(value);
end;

class function TIQ.GetConstTagName: string;
begin
  Result:=TagName+'-';
end;

end.

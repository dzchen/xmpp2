unit RosterManager;

interface
uses
  Jid,xmpp.iq.RosterIq,xmpp.iq.RosterItem,XmppConnection,classes,XMPPEvent
  ,Element,Xmpp.Client.Presence,XmppClientExtension;
type
  TRosterManager=class(TXmppClientExtension)
  private
    _isRosterReceived:Boolean;
    FOnRosterStart,FOnRosterEnd:tnotifyevent;
    FOnRosterItem:TRosterHandler;
    FPresenceChanged:TPresenceHandler;
    FsubscriptionReceived:TJidHandler;
    fitemAdded,fitemChanged,fitemRemoved:TJidHandler;
  public
    property isRosterReceived:boolean read _isRosterReceived;
    property OnRosterItem:TRosterHandler read FOnRosterItem write FOnRosterItem;
    property OnRosterStart:TNotifyEvent read FOnRosterStart write FOnRosterStart;
    property OnRosterEnd:TNotifyEvent read FOnRosterEnd write FOnRosterEnd;
    property OnPresenceChanged:TPresenceHandler read FPresenceChanged write FPresenceChanged;
    property OnSubscriptionReceived:TJidHandler read FsubscriptionReceived write FsubscriptionReceived;
    property OnItemAdded:TJidHandler read fitemAdded write fitemAdded;
    property OnItemChanged:TJidHandler read fitemChanged write fitemChanged;
    property OnItemRemoved:TJidHandler read fitemRemoved write fitemRemoved;
    constructor Create(con:TXmppConnection);
    procedure RemoveRosterItem(jid:TJID);
    procedure AddRosterItem(jid:TJID);overload;
    procedure UpdateRosterItem(jid:TJID);overload;
    procedure AddRosterItem(jid:TJID;nickname:string);overload;
    procedure UpdateRosterItem(jid:TJID;nickname:string);overload;
    procedure AddRosterItem(jid:TJID;nickname,group:string);overload;
    procedure UpdateRosterItem(jid:TJID;nickname,group:string);overload;
    procedure AddRosterItem(jid:TJID;nickname:string;group:array of string);overload;
    procedure UpdateRosterItem(jid:TJID;nickname:string;group:array of string);overload;
    function acceptSubscription(barejid,reason:string):boolean;
    function refuseSubscription(barejid,reason:string):boolean;
    function subscribe(barejid,reason:string):boolean;
    function unsubscribe(barejid,reason:string):boolean;
    function StreamParserElement(sender:TObject;e:TElement):boolean;override;
    procedure RequestRoster();
    procedure OnPresence(sender:Tobject;pres:Tpresence);
  end;
implementation
uses
  xmpp.client.iq,Xmpp.iq.roster,XmppClientConnection;
{ TRosterManager }

procedure TRosterManager.AddRosterItem(jid: TJID; nickname, group: string);
var
  s:array of string;
begin
  SetLength(s,1);
  s[0]:=group;
  AddRosterItem(jid,nickname,s);
end;

function TRosterManager.acceptSubscription(barejid, reason: string): boolean;
var
  pres:TPresence;
begin
  pres:=TPresence.Create();
  pres.PresenceType:='subscribed';
  pres.ToJid:=tjid.create(barejid);
  pres.Status:=reason;
  client.Send(pres);
end;

procedure TRosterManager.AddRosterItem(jid: TJID;nickname:string; group: array of string);
var
  rid:TRosterIq;
  ri:TRosterItem;
  s:string;
begin
  rid:=TRosterIq.Create;
  rid.IqType:='set';
  ri:=TRosterItem.Create;
  ri.Jid:=jid;
  if nickname<>'' then
    ri.ItemName:=nickname;
  for s in group do
      ri.AddGroup(s);
  rid.Query.AddRosterItem(ri);
  client.Send(rid);
end;

procedure TRosterManager.AddRosterItem(jid: TJID; nickname: string);
var
  s:array of string;
begin
  SetLength(s,0);
  AddRosterItem(jid,nickname,s);
end;

procedure TRosterManager.AddRosterItem(jid: TJID);
var
  s:array of string;
begin
  SetLength(s,0);
  AddRosterItem(jid,'',s);
end;

constructor TRosterManager.Create(con: TXmppConnection);
begin
  client:=(con);
end;

procedure TRosterManager.OnPresence(sender: Tobject; pres: Tpresence);
var
  jid:TJid;
begin
  jid:=pres.fromjid;
  if pres.PresenceType='subscribe'then
  begin
    if (Txmppclientconnection(client).autoAcceptSubscription) then
    begin
        acceptSubscription(jid.bare,'');

            subscribe(jid.bare,'');
    end
    else
    begin
      if Assigned(fsubscriptionreceived) then
        fsubscriptionreceived(self,jid);
    end;
  end
  else if(pres.PresenceType = 'subscribed')then
	begin

  end
			else if pres.PresenceType = 'unsubscribe' then
		begin

    end
			else if(pres.PresenceType = 'unsubscribed') then
			begin

      end
  else
  begin
    if Assigned(fpresenceChanged) then
        fpresenceChanged(self,pres);
  end;
end;

function TRosterManager.refuseSubscription(barejid, reason: string): boolean;
var
  pres:TPresence;
begin
  pres:=TPresence.Create();
  pres.PresenceType:='unsubscribed';
  pres.ToJid:=tjid.create(barejid);
  pres.Status:=reason;
  client.Send(pres);
end;

procedure TRosterManager.RemoveRosterItem(jid: TJID);
var
  riq:TRosterIq;
  ri:TRosterItem;
begin
  riq:=TRosterIq.Create;
  riq.IqType:='set';
  ri:=TRosterItem.Create;
  ri.Jid:=jid;
  ri.Subscription:='remove';
  riq.Query.AddRosterItem(ri);
  client.Send(riq);
end;

procedure TRosterManager.RequestRoster;
var
  iq:trosteriq;
begin
  if Txmppclientconnection(client).authenticated then
  begin
  iq:=trosteriq.create('get');
  client.send(iq);
  end;
end;

function TRosterManager.StreamParserElement(sender: TObject;
  e: TElement): boolean;
var
  iq:tiq;
  r:TRoster;
  rl:TList;
  i:integer;
begin
  result:=false;
  if e.Name='iq' then
  begin
    iq:=TIQ(e);
    if (iq<>nil) and (iq.Query<>nil) then
      if iq.Query.Namespace=TRoster.NameSpace then
      begin
        if (iq.IqType='result') then
        begin
          if Assigned(FOnRosterStart) then
            FOnRosterStart(Self);
          r:=TRoster(iq.Query);
          if r<>nil then
          begin
            rl:=r.GetRoster;
            for i:=0 to rl.Count-1 do
            begin
              if Assigned(fonrosteritem) then
                fonrosteritem(Self,TRosterItem(rl[i]));
            end;
            rl.Clear;
            rl.free;
          end;
          if Assigned(FOnRosterEnd) then
            FOnRosterEnd(Self);
//          if _connection.autopresence then
//            SendMyPresence;
        end
        else  if iq.iqtype='set' then
        begin
          r:=TRoster(iq.Query);
          if r<>nil then
          begin
            rl:=r.GetRoster;
            for i:=0 to rl.Count-1 do
            begin
              if TRosterItem(rl[i]).Subscription='remove' then
              begin
                if Assigned(fitemRemoved) then
                  fitemRemoved(Self,TRosterItem(rl[i]).jid);
              end
              else
              begin
                if Assigned(fitemadded) then
                  fitemadded(Self,TRosterItem(rl[i]).jid);
              end;
            end;

            rl.Clear;
            rl.free;
          end;

        end;
        result:=true;
      end;

  end;
end;

function TRosterManager.subscribe(barejid, reason: string): boolean;
var
  pres:TPresence;
begin
  pres:=TPresence.Create();
  pres.PresenceType:='subscribe';
  pres.ToJid:=tjid.create(barejid);
  pres.Status:=reason;
  client.Send(pres);
end;

function TRosterManager.unsubscribe(barejid, reason: string): boolean;
var
  pres:TPresence;
begin
  pres:=TPresence.Create();
  pres.PresenceType:='unsubscribe';
  pres.ToJid:=tjid.create(barejid);
  pres.Status:=reason;
  client.Send(pres);
end;

procedure TRosterManager.UpdateRosterItem(jid: TJID; nickname, group: string);
var
  s:array of string;
begin
  SetLength(s,1);
  s[0]:=group;
  AddRosterItem(jid,nickname,s);
end;

procedure TRosterManager.UpdateRosterItem(jid: TJID;nickname:string; group: array of string);
begin
  AddRosterItem(jid,nickname,group);
end;

procedure TRosterManager.UpdateRosterItem(jid: TJID);
var
  s:array of string;
begin
  SetLength(s,0);
  AddRosterItem(jid,'',s);
end;

procedure TRosterManager.UpdateRosterItem(jid: TJID; nickname: string);
var
  s:array of string;
begin
  SetLength(s,0);
  AddRosterItem(jid,nickname,s);
end;
end.

unit XmppId;

interface
uses
  SysUtils;
type
  IdType=(Numeric,Guid);
  TXmppId=class
  private
    class
    var _id:LongInt;
    _prefix:string;
    _type:IdType;
  public
    class property IdType:IdType read _type write _type;
    class function GetNextId():string;
    class procedure Reset();
    class property Prefix:string read _prefix write _prefix;
  end;

implementation

{ TId }

class function TXmppId.GetNextId: string;
var
  V: TGUID;
  S: String;
begin
  if(_type=Numeric) then
  begin
    _id:=_id+1;
    Result:=_prefix+inttostr(_Id);
  end
  else
  begin
    V := TGUID.NewGuid;
    S := V.ToString;
    S:=StringReplace(v.tostring,'{','',[rfIgnoreCase]);
    S:=StringReplace(S,'}','',[rfIgnoreCase]);
    Result:=_prefix+s;
  end;
end;

class procedure TXmppId.Reset;
begin
  _id:=0;
end;
initialization
TXmppId._id:=0;
TXmppId._type:=Numeric;
TXmppId._prefix:='agsXMPP_';
//
//
end.


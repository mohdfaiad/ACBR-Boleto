{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Jean Patrick Figueiredo dos Santos     }
{                                       Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{         Silvio Cl�cio - xmailer - https://github.com/silvioprog/xmailer      }
{         Projeto PHPMailer - https://github.com/Synchro/PHPMailer             }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 11/10/2013: Primeira Versao
|*    Jean Patrick Figueiredo dos Santos
|*
******************************************************************************}

unit ACBrMail;

{$I ACBr.inc}

interface

uses
  Classes, syncobjs, SysUtils,
  SSL_OpenSSL, SMTPSend, MimePart, MimeMess, SynaChar, SynaUtil,
  ACBrBase;

type

  TMailStatus = (pmsStartProcess, pmsConfigHeaders, pmsAddingMimeParts,
                 pmsLoginSMTP, pmsStartSends, pmsSendTo, pmsSendCC, pmsSendBCC,
                 pmsSendReplyTo, pmsSendData, pmsLogoutSMTP, pmsDone, pmsError);

  TMailCharset = TMimeChar;

  TMailAttachments = array of record
    FileName: string;
    Stream: TMemoryStream;
    NameRef: string;
  end;

  TACBrMail = class;

  TACBrOnMailProcess = procedure(const AMail: TACBrMail; const aStatus: TMailStatus) of object;
  TACBrOnMailException = procedure(const AMail: TACBrMail; const E: Exception; var ThrowIt: Boolean) of object;

  { TACBrMailThread }

  TACBrMailThread = class(TThread)
  private
    FACBrMail : TACBrMail;
    FException: Exception;
    FThrowIt: Boolean;
    FStatus: TMailStatus;
    FOnMailProcess: TACBrOnMailProcess;
    FOnMailException: TACBrOnMailException;
    FOnBeforeMailProcess: TNotifyEvent;
    FOnAfterMailProcess: TNotifyEvent;

    procedure MailException(const AMail: TACBrMail; const E: Exception; var ThrowIt: Boolean);
    procedure DoMailException;
    procedure MailProcess(const AMail: TACBrMail; const aStatus: TMailStatus);
    procedure DoMailProcess;
    procedure BeforeMailProcess(Sender: TObject);
    procedure DoBeforeMailProcess;
    procedure AfterMailProcess(Sender: TObject);
    procedure DoAfterMailProcess;

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner : TACBrMail);
  end;

  { TACBrMail }

  TACBrMail = class(TACBrComponent)
  private
    fSMTP                : TSMTPSend;
    fMIMEMess            : TMimeMess;
    fArqMIMe             : TMemoryStream;

    fReadingConfirmation : boolean;
    fOnMailProcess       : TACBrOnMailProcess;
    fOnMailException     : TACBrOnMailException;

    fIsHTML              : boolean;
    fAttempts            : Byte;
    fFrom                : string;
    fFromName            : string;
    fSubject             : string;
    fBody                : TStringList;
    fAltBody             : TStringList;
    fAttachments         : TMailAttachments;
    fReplyTo             : TStringList;
    fBCC                 : TStringList;
    fUseThread           : boolean;

    fDefaultCharsetCode  : TMimeChar;
    fIDECharsetCode      : TMimeChar;

    fOnAfterMailProcess  : TNotifyEvent;
    fOnBeforeMailProcess : TNotifyEvent;

    fGetLastSmtpError    : String;

    function GetHost: string;
    function GetPort: string;
    function GetUsername: string;
    function GetPassword: string;
    function GetFullSSL: Boolean;
    function GetAutoTLS: Boolean;
    procedure SetHost(aValue: string);
    procedure SetPort(aValue: string);
    procedure SetUsername(aValue: string);
    procedure SetPassword(aValue: string);
    procedure SetFullSSL(aValue: Boolean);
    procedure SetAutoTLS(aValue: Boolean);

    function GetPriority: TMessPriority;
    procedure SetPriority(aValue: TMessPriority);

    procedure SmtpError(const pMsgError: string);

    procedure DoException(E: Exception);

  protected
    procedure SendMail;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure MailProcess(const aStatus: TMailStatus);
    procedure Send(UseThreadNow: Boolean); overload;
    procedure Send; overload;
    procedure Clear;
    procedure SaveToFile(const AFileName: String);
    function SaveToStream(AStream: TStream): Boolean;

    procedure AddAttachment(aFileName: string; aNameRef: string); overload;
    procedure AddAttachment(aFileName: string); overload;
    procedure AddAttachment(aStream: TStream; aNameRef: string); overload;
    procedure AddAttachment(aStream: TStream); overload;
    procedure ClearAttachments;

    procedure AddAddress(aEmail: string; aName: string = '');
    procedure AddReplyTo(aEmail: string; aName: string = '');
    procedure AddCC(aEmail: string; aName: string = '');
    procedure AddBCC(aEmail: string);

    property SMTP: TSMTPSend read fSMTP;
    property MIMEMess: TMimeMess read fMIMEMess;
    property Attachments: TMailAttachments read fAttachments;
    property BCC: TStringList read fBCC;
    property ReplyTo: TStringList read fReplyTo;

    property AltBody: TStringList read fAltBody;
    property Body: TStringList read fBody;

    property GetLastSmtpError: string read fGetLastSmtpError;

  published
    property Host: string read GetHost write SetHost;
    property Port: string read GetPort write SetPort;
    property Username: string read GetUsername write SetUsername;
    property Password: string read GetPassword write SetPassword;
    property SetSSL: boolean read GetFullSSL write SetFullSSL;
    property SetTLS: boolean read GetAutoTLS write SetAutoTLS;
    property Priority: TMessPriority read GetPriority write SetPriority default MP_normal;
    property ReadingConfirmation: boolean read fReadingConfirmation write fReadingConfirmation default False;
    property IsHTML: boolean read fIsHTML write fIsHTML default False;
    property UseThread: boolean read fUseThread write fUseThread default False;
    property Attempts: Byte read fAttempts write fAttempts;
    property From: string read fFrom write fFrom;
    property FromName: string read fFromName write fFromName;
    property Subject: string read fSubject write fSubject;
    property DefaultCharset: TMailCharset read fDefaultCharsetCode write fDefaultCharsetCode;
    property IDECharset: TMailCharset read fIDECharsetCode write fIDECharsetCode;
    property OnBeforeMailProcess: TNotifyEvent read fOnBeforeMailProcess write fOnBeforeMailProcess;
    property OnMailProcess: TACBrOnMailProcess read fOnMailProcess write fOnMailProcess;
    property OnAfterMailProcess: TNotifyEvent read fOnAfterMailProcess write fOnAfterMailProcess;
    property OnMailException: TACBrOnMailException read fOnMailException write fOnMailException;
  end;

procedure SendEmailByThread( MailToClone: TACBrMail);

var
  MailCriticalSection : TCriticalSection;

implementation

Uses
  strutils{$IFDEF FPC}, FileUtil {$ENDIF};

procedure SendEmailByThread(MailToClone: TACBrMail);
var
  AMail: TACBrMail;
begin
  if not Assigned(MailToClone) then
    raise Exception.Create( 'MailToClone not specified' );

  AMail := TACBrMail.Create(nil);
  AMail.Assign( MailToClone );

  // Thread is FreeOnTerminate, and also will destroy "AMail"
  TACBrMailThread.Create(AMail);
end;

{ TACBrMail }

function TACBrMail.GetHost: string;
begin
  Result := fSMTP.TargetHost;
end;

function TACBrMail.GetPort: string;
begin
  Result := fSMTP.TargetPort;
end;

function TACBrMail.GetUsername: string;
begin
  Result := fSMTP.UserName;
end;

function TACBrMail.GetPassword: string;
begin
  Result := fSMTP.Password;
end;

function TACBrMail.GetFullSSL: Boolean;
begin
  Result := fSMTP.FullSSL;
end;

function TACBrMail.GetAutoTLS: Boolean;
begin
  Result := fSMTP.AutoTLS;
end;

procedure TACBrMail.SetHost(aValue: string);
begin
  fSMTP.TargetHost := aValue;
end;

procedure TACBrMail.SetPort(aValue: string);
begin
  fSMTP.TargetPort := aValue;
end;

procedure TACBrMail.SetUsername(aValue: string);
begin
  fSMTP.UserName := aValue;
end;

procedure TACBrMail.SetPassword(aValue: string);
begin
  fSMTP.Password := aValue;
end;

procedure TACBrMail.SetFullSSL(aValue: Boolean);
begin
  fSMTP.FullSSL := aValue;
end;

procedure TACBrMail.SetAutoTLS(aValue: Boolean);
begin
  fSMTP.AutoTLS := aValue;
end;

function TACBrMail.GetPriority: TMessPriority;
begin
  Result := fMIMEMess.Header.Priority;
end;

procedure TACBrMail.SetPriority(aValue: TMessPriority);
begin
  fMIMEMess.Header.Priority := aValue;
end;

procedure TACBrMail.SmtpError(const pMsgError: string);
begin
  try
    fGetLastSmtpError := pMsgError;
    MailProcess(pmsError);
    DoException( Exception.Create(pMsgError) );
  finally
    Clear;
  end;
end;

procedure TACBrMail.DoException(E: Exception);
Var
  ThrowIt: Boolean;
begin
  if Assigned(fOnMailException) then
  begin
    ThrowIt := True;
    fOnMailException( Self, E, ThrowIt );

    if ThrowIt then
      raise E
    else
    begin
      E.Free;
      Abort;
    end;
  end
  else
    raise E;
end;

procedure TACBrMail.Clear;
begin
  ClearAttachments;
  fSMTP.Reset;
  fMIMEMess.Header.Clear;
  fMIMEMess.Clear;
  fReplyTo.Clear;
  fBCC.Clear;
  fSubject := '';
  fBody.Clear;
  fAltBody.Clear;
end;

procedure TACBrMail.SaveToFile(const AFileName: String);
begin
  if AFileName <> '' then
    fArqMIMe.SaveToFile(AFileName);
end;

procedure TACBrMail.MailProcess(const aStatus: TMailStatus);
begin
  if Assigned(fOnMailProcess) then
    fOnMailProcess(Self, aStatus);
end;

constructor TACBrMail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fSMTP := TSMTPSend.Create;
  fMIMEMess := TMimeMess.Create;
  fAltBody := TStringList.Create;
  fBody := TStringList.Create;
  fArqMIMe := TMemoryStream.Create;

  fOnBeforeMailProcess := nil;
  fOnAfterMailProcess := nil;

  SetLength(fAttachments, 0);
  SetPriority(MP_normal);
  fDefaultCharsetCode := UTF_8;
  fIDECharsetCode := {$IFDEF FPC}UTF_8{$ELSE}CP1252{$ENDIF};
  fReadingConfirmation := False;
  fIsHTML := False;
  fUseThread := False;
  fAttempts := 3;
  fFrom := '';
  fFromName := '';
  fSubject := '';

  fReplyTo := TStringList.Create;
  {$IFDEF FPC}
  fReplyTo.StrictDelimiter := True;
  {$ENDIF}
  fReplyTo.Delimiter := ';';

  fBCC := TStringList.Create;
  {$IFDEF FPC}
  fBCC.StrictDelimiter := True;
  {$ENDIF}
  fBCC.Delimiter := ';';

  // NOTAR ISSO: fSMTP.Sock.OnStatus := ;

end;

destructor TACBrMail.Destroy;
begin
  ClearAttachments;
  fAltBody.Free;
  fBody.Free;
  fBCC.Free;
  fReplyTo.Free;
  fMIMEMess.Free;
  fSMTP.Free;
  fArqMIMe.Free;
  
  inherited Destroy;
end;

procedure TACBrMail.Assign(Source: TPersistent);
var
  i: Integer;
begin
  if not (Source is TACBrMail) then
    raise Exception.Create('Source must be TACBrMail');

  with TACBrMail(Source) do
  begin
    Self.Host := Host;
    Self.Port := Port;
    Self.Username := Username;
    Self.Password := Password;
    Self.SetSSL := SetSSL;
    Self.SetTLS := SetTLS;
    Self.Priority := Priority;
    Self.ReadingConfirmation := ReadingConfirmation;
    Self.IsHTML := IsHTML;
    Self.UseThread := UseThread;
    Self.Attempts := Attempts;
    Self.From := From;
    Self.FromName := FromName;
    Self.Subject := Subject;
    Self.DefaultCharset := DefaultCharset;
    Self.IDECharset := IDECharset;
    Self.OnBeforeMailProcess := OnBeforeMailProcess;
    Self.OnMailProcess := OnMailProcess;
    Self.OnAfterMailProcess := OnAfterMailProcess;
    Self.OnMailException := OnMailException;

    for i := 0 to Length(Attachments) - 1 do
    begin
      if Attachments[i].Stream <> Nil then
        Self.AddAttachment(Attachments[i].Stream, Attachments[i].NameRef)
      else
        Self.AddAttachment(Attachments[i].FileName, Attachments[i].NameRef);
    end;

    Self.AltBody.Assign(AltBody);
    Self.Body.Assign(Body);
    Self.ReplyTo.Assign(ReplyTo);
    Self.BCC.Assign(BCC);

    Self.MIMEMess.Header.ToList.Assign( MIMEMess.Header.ToList );
    Self.MIMEMess.Header.CCList.Assign( MIMEMess.Header.CCList );
    Self.MIMEMess.Header.Organization := MIMEMess.Header.Organization;
    Self.MIMEMess.Header.CustomHeaders.Assign( MIMEMess.Header.CustomHeaders );
    Self.MIMEMess.Header.Date := MIMEMess.Header.Date;
    Self.MIMEMess.Header.XMailer := MIMEMess.Header.XMailer;
  end;
end;

procedure TACBrMail.Send(UseThreadNow: Boolean);
begin
  if UseThreadNow then
    SendEmailByThread(Self)
  else
    SendMail;
end;

procedure TACBrMail.Send;
begin
  Send( UseThread );
end;

procedure TACBrMail.SendMail;
var
  vAttempts: Byte;
  i, c: Integer;
  MultiPartParent, MimePartAttach : TMimePart;
  NeedMultiPartRelated, BodyHasImage: Boolean;

  function InternalCharsetConversion(const Value: String; CharFrom: TMimeChar;
    CharTo: TMimeChar): String;
  begin
   Result := string( CharsetConversion( AnsiString( Value), CharFrom, CharTo ));
  end;

begin
  if Assigned(OnBeforeMailProcess) then
    OnBeforeMailProcess( self );

  MailProcess(pmsStartProcess);

  // Encoding according to IDE and Mail Charset //
  if fDefaultCharsetCode <> fIDECharsetCode then
  begin
    if fBody.Count > 0 then
      fBody.Text := InternalCharsetConversion(fBody.Text, fIDECharsetCode, fDefaultCharsetCode);

    if fAltBody.Count > 0 then
      fAltBody.Text := InternalCharsetConversion(fAltBody.Text, fIDECharsetCode, fDefaultCharsetCode);
  end;

  // Configuring the Headers //
  MailProcess(pmsConfigHeaders);

  fMIMEMess.Header.CharsetCode := fDefaultCharsetCode;

  if fDefaultCharsetCode <> fIDECharsetCode then
    fMIMEMess.Header.Subject := InternalCharsetConversion(fSubject, fIDECharsetCode, fDefaultCharsetCode)
  else
    fMIMEMess.Header.Subject := fSubject;

  if Trim(fFromName) <> '' then
    fMIMEMess.Header.From := '"' + fFromName + '" <' + From + '>'
  else
    fMIMEMess.Header.From := fFrom;

  if fReplyTo.Count > 0 then
    fMIMEMess.Header.ReplyTo := fReplyTo.DelimitedText;

  if fReadingConfirmation then
    fMIMEMess.Header.CustomHeaders.Insert(0, 'Disposition-Notification-To: ' + fFrom);

  fMIMEMess.Header.XMailer := 'Synapse - ACBrMail';

  // Adding MimeParts //
  // Inspiration: http://www.ararat.cz/synapse/doku.php/public:howto:mimeparts
  MailProcess(pmsAddingMimeParts);

  NeedMultiPartRelated := (fIsHTML and (fBody.Count > 0)) and (fAltBody.Count > 0);

  // The Root //
  MultiPartParent := fMIMEMess.AddPartMultipart( IfThen(NeedMultiPartRelated, 'alternative', 'mixed'), nil );

  // Text part //
  if fAltBody.Count > 0 then
  begin
    with fMIMEMess.AddPart( MultiPartParent ) do
    begin
      fAltBody.SaveToStream(DecodedLines);
      Primary := 'text';
      Secondary := 'plain';
      Description := 'Message text';
      Disposition := 'inline';
      CharsetCode := fDefaultCharsetCode;
      TargetCharset := fDefaultCharsetCode;
      EncodingCode := ME_QUOTED_PRINTABLE;
      EncodePart;
      EncodePartHeader;
    end;
  end;

  // Need New branch ? //
  if NeedMultiPartRelated then
    MultiPartParent := fMIMEMess.AddPartMultipart( 'related', MultiPartParent );

  if fIsHTML and (fBody.Count > 0) then
  begin
    // Adding HTML Part //
    with fMIMEMess.AddPart( MultiPartParent ) do
    begin
      fBody.SaveToStream(DecodedLines);
      Primary := 'text';
      Secondary := 'html';
      Description := 'HTML text';
      Disposition := 'inline';
      CharsetCode := fDefaultCharsetCode;
      TargetCharset := fDefaultCharsetCode;
      EncodingCode := ME_QUOTED_PRINTABLE;
      EncodePart;
      EncodePartHeader;
    end;
  end;

  // Adding the Attachments //
  for i := 0 to Length(fAttachments) - 1 do
  begin

    if (Trim(fAttachments[i].FileName) = '') then   // Using Stream
    begin
      if (Trim(fAttachments[i].NameRef) = '') then
        fAttachments[i].NameRef := 'file_' + FormatDateTime('hhnnsszzz',Now);

      BodyHasImage := pos(':'+LowerCase(fAttachments[i].NameRef),
                          LowerCase(fBody.Text)) > 0;

      if fIsHTML and BodyHasImage then
        MimePartAttach := fMIMEMess.AddPartHTMLBinary(
                                      fAttachments[i].Stream,
                                      fAttachments[i].NameRef,
                                      '<' + fAttachments[i].NameRef + '>',
                                      MultiPartParent )
      else
        MimePartAttach := fMIMEMess.AddPartBinary(
                                      fAttachments[i].Stream,
                                      fAttachments[i].NameRef,
                                      MultiPartParent );

    end
    else
    begin
      if (Trim(fAttachments[i].NameRef) = '') then
        fAttachments[i].NameRef := ExtractFileName(fAttachments[i].FileName);

      BodyHasImage := pos(':'+LowerCase(fAttachments[i].NameRef),
                          LowerCase(fBody.Text)) > 0;

      if fIsHTML and BodyHasImage then
        MimePartAttach := fMIMEMess.AddPartHTMLBinaryFromFile(
                                      fAttachments[i].FileName,
                                      '<' + fAttachments[i].NameRef + '>',
                                      MultiPartParent )
      else
        MimePartAttach := fMIMEMess.AddPartBinaryFromFile(
                                      fAttachments[i].FileName,
                                      MultiPartParent );

    end;

    if Assigned(MimePartAttach) then
    begin
      MimePartAttach.Description := fAttachments[i].NameRef;
      MimePartAttach.EncodePartHeader;
    end;
  end;

  fMIMEMess.EncodeMessage;

  fArqMIMe.Clear;
  fMIMEMess.Lines.SaveToStream(fArqMIMe);

  // DEBUG //
  //SaveToFile('.\Mail.eml');

  // Login in SMTP //
  MailProcess(pmsLoginSMTP);

  for vAttempts := 1 to fAttempts do
  begin
    if fSMTP.Login and fSMTP.AuthDone then
      Break;

    if vAttempts >= fAttempts then
      SmtpError('SMTP Error: Unable to Login.');
  end;

  // Sending Mail Form //
  MailProcess(pmsStartSends);

  for vAttempts := 1 to fAttempts do
  begin
    if fSMTP.MailFrom(fFrom, Length(fFrom)) then
      Break;

    if vAttempts >= fAttempts then
      SmtpError('SMTP Error: Unable to send MailFrom.');
  end;

  // Sending MailTo //
  MailProcess(pmsSendTo);

  for i := 0 to fMIMEMess.Header.ToList.Count - 1 do
  begin
    for vAttempts := 1 to fAttempts do
    begin
      if fSMTP.MailTo(GetEmailAddr(fMIMEMess.Header.ToList.Strings[i]))then
        Break;

      if vAttempts >= fAttempts then
        SmtpError('SMTP Error: Unable to send MailTo.');
    end;
  end;

  // Sending Carbon Copies //
  c := fMIMEMess.Header.CCList.Count;
  if c > 0 then
    MailProcess(pmsSendCC);

  for i := 0 to c - 1 do
  begin
    for vAttempts := 1 to fAttempts do
    begin
      if fSMTP.MailTo(GetEmailAddr(fMIMEMess.Header.CCList.Strings[i])) then
        Break;

      if vAttempts >= fAttempts then
        SmtpError('SMTP Error: Unable to send CC list.');
    end;
  end;

  // Sending Blind Carbon Copies //
  c := fBCC.Count;
  if c > 0 then
    MailProcess(pmsSendBCC);

  for i := 0 to c - 1 do
  begin
    for vAttempts := 1 to fAttempts do
    begin
      if fSMTP.MailTo(GetEmailAddr(fBCC.Strings[I])) then
        Break;

      if vAttempts >= fAttempts then
        SmtpError('SMTP Error: Unable to send BCC list.');
    end;
  end;

  // Sending Copies to Reply To //
  c := fReplyTo.Count;
  if c > 0 then
    MailProcess(pmsSendReplyTo);

  for i := 0 to c - 1 do
  begin
    for vAttempts := 1 to fAttempts do
    begin
      if fSMTP.MailTo(GetEmailAddr(fReplyTo.Strings[I])) then
        Break;

      if vAttempts >= fAttempts then
        SmtpError('SMTP Error: Unable to send ReplyTo list.');
    end;
  end;

  // Sending MIMEMess Data //
  MailProcess(pmsSendData);

  for vAttempts := 1 to fAttempts do
  begin
    if fSMTP.MailData(fMIMEMess.Lines) then
      Break;

    if vAttempts >= fAttempts then
      SmtpError('SMTP Error: Unable to send Mail data.');
  end;

  // Login out from SMTP //
  MailProcess(pmsLogoutSMTP);

  for vAttempts := 1 to fAttempts do
  begin
    if fSMTP.Logout then
      Break;

    if vAttempts >= fAttempts then
      SmtpError('SMTP Error: Unable to Logout.');
  end;

  // Done //
  try
    MailProcess(pmsDone);

    if Assigned(OnAfterMailProcess) then
      OnAfterMailProcess( self );
  finally
    Clear;
  end;
end;

procedure TACBrMail.ClearAttachments;
var
  i: Integer;
begin
  if Length(fAttachments) > 0 then
  begin
    for i := 0 to Length(fAttachments) - 1 do
      if Assigned(fAttachments[i].Stream) then
        fAttachments[i].Stream.Free;

    SetLength(fAttachments, 0);
  end;
end;

procedure TACBrMail.AddAttachment(aFileName: string; aNameRef: string);
var
  i: integer;
begin

  {$IFDEF FPC}
  if not FileExistsUTF8(aFileName) then
  begin
    if not FileExists(aFileName) then
      DoException( Exception.Create('Add Attachment: File not Exists.') );
  end
  else
    aFileName := Utf8ToAnsi(aFileName);
  {$ELSE}
  if not FileExists(aFileName) then
    DoException( Exception.Create('Add Attachment: File not Exists.') );
  {$ENDIF}

  i := Length(fAttachments);
  SetLength(fAttachments, i + 1);
  fAttachments[i].FileName := aFileName;
  fAttachments[i].Stream := nil;
  fAttachments[i].NameRef := aNameRef;
end;

procedure TACBrMail.AddAttachment(aFileName: string);
begin
  AddAttachment(aFileName, '');
end;

procedure TACBrMail.AddAttachment(aStream: TStream; aNameRef: string);
var
  i: integer;
begin
  if not Assigned(aStream) then
    DoException( Exception.Create('Add Attachment: Access Violation.') );

  i := Length(fAttachments);
  SetLength(fAttachments, i + 1);

  aStream.Position := 0;
  fAttachments[i].FileName := '';
  fAttachments[i].Stream := TMemoryStream.Create;
  fAttachments[i].Stream.Position := 0;
  fAttachments[i].Stream.CopyFrom(aStream, aStream.Size);
  fAttachments[i].NameRef := aNameRef;
end;

procedure TACBrMail.AddAttachment(aStream: TStream);
begin
  AddAttachment(aStream, '');
end;

procedure TACBrMail.AddAddress(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    fMIMEMess.Header.ToList.Add('"' + aName + '" <' + aEmail + '>')
  else
    fMIMEMess.Header.ToList.Add(aEmail);
end;

procedure TACBrMail.AddReplyTo(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    fReplyTo.Add('"' + aName + '" <' + aEmail + '>')
  else
    fReplyTo.Add(aEmail);
end;

procedure TACBrMail.AddCC(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    fMIMEMess.Header.CCList.Add('"' + aName + '" <' + aEmail + '>')
  else
    fMIMEMess.Header.CCList.Add(aEmail);
end;

procedure TACBrMail.AddBCC(aEmail: string);
begin
  fBCC.Add(aEmail);
end;

function TACBrMail.SaveToStream(AStream: TStream): Boolean;
begin
  Result := True;
  try
    fArqMIMe.SaveToStream(AStream);
  except
    Result := False;
  end;
end;

{ TACBrMailThread }

constructor TACBrMailThread.Create(AOwner: TACBrMail);
begin
  FreeOnTerminate  := True;
  FACBrMail        := AOwner;

  inherited Create(False);
end;

procedure TACBrMailThread.Execute;
begin
  FStatus := pmsStartProcess;

  // Save events pointers
  FOnMailProcess   := FACBrMail.OnMailProcess ;
  FOnMailException := FACBrMail.OnMailException;
  FOnBeforeMailProcess := FACBrMail.OnBeforeMailProcess;
  FOnAfterMailProcess := FACBrMail.OnAfterMailProcess;
  MailCriticalSection.Acquire;
  try
    // Redirect events to Internal methods, to use Synchronize
    FACBrMail.OnMailException := MailException;
    FACBrMail.OnMailProcess := MailProcess;
    FACBrMail.OnBeforeMailProcess := BeforeMailProcess;
    FACBrMail.OnAfterMailProcess := AfterMailProcess;
    FACBrMail.UseThread := False;

    if (not Self.Terminated) then
      FACBrMail.SendMail;
  finally
    // Discard ACBrMail copy
    FACBrMail.Free;
    Terminate;
    MailCriticalSection.Release;
  end;
end;

procedure TACBrMailThread.MailProcess(const AMail: TACBrMail;
  const aStatus: TMailStatus);
begin
  FStatus := aStatus;
  Synchronize(DoMailProcess);
end;

procedure TACBrMailThread.DoMailProcess;
begin
  if Assigned(FOnMailProcess) then
    FOnMailProcess(FACBrMail, FStatus) ;
end;

procedure TACBrMailThread.BeforeMailProcess(Sender: TObject);
begin
  Synchronize(DoBeforeMailProcess);
end;

procedure TACBrMailThread.DoBeforeMailProcess;
begin
  if Assigned(FOnBeforeMailProcess) then
    FOnBeforeMailProcess( FACBrMail );
end;

procedure TACBrMailThread.AfterMailProcess(Sender: TObject);
begin
  Synchronize(DoAfterMailProcess);
end;

procedure TACBrMailThread.DoAfterMailProcess;
begin
  if Assigned(FOnAfterMailProcess) then
    FOnAfterMailProcess( FACBrMail );
end;

procedure TACBrMailThread.MailException(const AMail: TACBrMail;
  const E: Exception; var ThrowIt: Boolean);
begin
  FException := E;
  Synchronize(DoMailException);
  ThrowIt := False;
end;

procedure TACBrMailThread.DoMailException;
begin
  FThrowIt := False;
  if Assigned(FOnMailException) then
    FOnMailException(FACBrMail, FException, FThrowIt);
end;

initialization
  MailCriticalSection := TCriticalSection.Create;

finalization;
  MailCriticalSection.Free;

end.


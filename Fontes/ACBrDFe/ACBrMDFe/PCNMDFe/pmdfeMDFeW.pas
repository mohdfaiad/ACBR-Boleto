{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pmdfeMDFeW;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pmdfeConversaoMDFe, pmdfeMDFe, ACBrUtil;

type

  TGeradorOpcoes = class;

  TMDFeW = class(TPersistent)
  private
    FGerador: TGerador;
    FMDFe: TMDFe;
    FOpcoes: TGeradorOpcoes;
    FVersaoDF: TVersaoMDFe;

    procedure GerarInfMDFe;       // Nivel 0

    procedure GerarIde;           // Nivel 1
    procedure GerarinfMunCarrega; // Nivel 2
    procedure GerarinfPercurso;   // Nivel 2

    procedure GerarEmit;          // Nivel 1
    procedure GerarEnderEmit;     // Nivel 2

    procedure GerarInfModal;      // Nivel 1
    procedure GerarRodo;          // Nivel 2
    procedure GerarAereo;         // Nivel 2
    procedure GerarAquav;         // Nivel 2
    procedure GerarFerrov;        // Nivel 2

    procedure GerarInfDoc;        // Nivel 1
    procedure GerarTot;           // Nivel 1
    procedure GerarLacres;        // Nivel 1
    procedure GerarautXML;        // Nivel 1
    procedure GerarInfAdic;       // Nivel 1

    procedure AjustarMunicipioUF(var xUF: String; var xMun: String; var cMun: Integer; cPais: Integer; vxUF, vxMun: String; vcMun: Integer);
    function ObterNomeMunicipio(const xMun, xUF: String; const cMun: Integer): String;
  public
    constructor Create(AOwner: TMDFe);
    destructor Destroy; override;
    function GerarXml: boolean;
    function ObterNomeArquivo: String;
  published
    property Gerador: TGerador      read FGerador  write FGerador;
    property MDFe: TMDFe            read FMDFe     write FMDFe;
    property Opcoes: TGeradorOpcoes read FOpcoes   write FOpcoes;
    property VersaoDF: TVersaoMDFe  read FVersaoDF write FVersaoDF;
  end;

  TGeradorOpcoes = class(TPersistent)
  private
    FAjustarTagNro: boolean;
    FNormatizarMunicipios: boolean;
    FGerarTagAssinatura: TpcnTagAssinatura;
    FPathArquivoMunicipios: String;
    FValidarInscricoes: boolean;
    FValidarListaServicos: boolean;
  published
    property AjustarTagNro: boolean                read FAjustarTagNro         write FAjustarTagNro;
    property NormatizarMunicipios: boolean         read FNormatizarMunicipios  write FNormatizarMunicipios;
    property GerarTagAssinatura: TpcnTagAssinatura read FGerarTagAssinatura    write FGerarTagAssinatura;
    property PathArquivoMunicipios: String         read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property ValidarInscricoes: boolean            read FValidarInscricoes     write FValidarInscricoes;
    property ValidarListaServicos: boolean         read FValidarListaServicos  write FValidarListaServicos;
  end;

implementation

{ TMDFeW }

constructor TMDFeW.Create(AOwner: TMDFe);
begin
  FMDFe := AOwner;

  FGerador                  := TGerador.Create;
  FGerador.FIgnorarTagNivel := '|?xml version|MDFe xmlns|infMDFe versao|';

  FOpcoes                       := TGeradorOpcoes.Create;
  FOpcoes.FAjustarTagNro        := True;
  FOpcoes.FNormatizarMunicipios := False;
  FOpcoes.FGerarTagAssinatura   := taSomenteSeAssinada;
  FOpcoes.FValidarInscricoes    := False;
  FOpcoes.FValidarListaServicos := False;
end;

destructor TMDFeW.Destroy;
begin
  FGerador.Free;
  FOpcoes.Free;
  inherited Destroy;
end;

function TMDFeW.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(MDFe.infMDFe.Id) + '-mdfe.xml';
end;

function TMDFeW.GerarXml: boolean;
var
  chave: AnsiString;
  Gerar: boolean;
  xProtMDFe: String;
begin
  chave := '';

  if not GerarChave(Chave, MDFe.ide.cUF, MDFe.ide.cMDF, StrToInt(MDFe.ide.modelo),
                    MDFe.ide.serie, MDFe.ide.nMDF, StrToInt(TpEmisToStr(MDFe.ide.tpEmis)),
                    MDFe.ide.dhEmi, MDFe.emit.CNPJ) then
    Gerador.wAlerta('#001', 'infMDFe', DSC_CHAVE, ERR_MSG_GERAR_CHAVE);

  chave := StringReplace(chave,'NFe','MDFe',[rfReplaceAll]);

//  if trim(MDFe.infMDFe.Id) = '' then
    MDFe.infMDFe.Id := chave;
(*
  if (copy(MDFe.infMDFe.Id, 1, 4) <> 'MDFe') then
    MDFe.infMDFe.Id := 'MDFe' + MDFe.infMDFe.Id;

  if (Trim(MDFe.infMDFe.Id) = '') or (not ValidarChave(MDFe.infMDFe.Id)) then
     MDFe.infMDFe.Id := chave
  else
   begin
     MDFe.infMDFe.Id := StringReplace( UpperCase(MDFe.infMDFe.Id), 'MDFE', '', [rfReplaceAll] ) ;
     MDFe.infMDFe.Id := 'MDFe' + MDFe.infMDFe.Id;
   end;
*)
  MDFe.ide.cDV  := RetornarDigito(MDFe.infMDFe.Id);
  MDFe.Ide.cMDF := RetornarCodigoNumerico(MDFe.infMDFe.Id, 2);

  // Carrega Layout que sera utilizado para gera o txt
  Gerador.LayoutArquivoTXT.Clear;
  Gerador.ArquivoFormatoXML := '';
  Gerador.ArquivoFormatoTXT := '';

  Gerador.wGrupo(ENCODING_UTF8, '', False);

  if MDFe.procMDFe.nProt <> ''
   then Gerador.wGrupo('mdfeProc versao="' + MDFeEnviMDFe + '" ' + NAME_SPACE_MDFe, '');

  Gerador.wGrupo('MDFe ' + NAME_SPACE_MDFe);
  Gerador.wGrupo('infMDFe Id="' + MDFe.infMDFe.ID + '" versao="' + MDFeEnviMDFe + '"');
  GerarInfMDFe;
  Gerador.wGrupo('/infMDFe');

  if FOpcoes.GerarTagAssinatura <> taNunca then
  begin
    Gerar := true;
    if FOpcoes.GerarTagAssinatura = taSomenteSeAssinada then
      Gerar := ((MDFe.signature.DigestValue <> '') and (MDFe.signature.SignatureValue <> '') and (MDFe.signature.X509Certificate <> ''));
    if FOpcoes.GerarTagAssinatura = taSomenteParaNaoAssinada then
      Gerar := ((MDFe.signature.DigestValue = '') and (MDFe.signature.SignatureValue = '') and (MDFe.signature.X509Certificate = ''));
    if Gerar then
    begin
      FMDFe.signature.URI := OnlyNumber(MDFe.infMDFe.ID);
      FMDFe.signature.Gerador.Opcoes.IdentarXML := Gerador.Opcoes.IdentarXML;
      FMDFe.signature.GerarXML;
      Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML + FMDFe.signature.Gerador.ArquivoFormatoXML;
    end;
  end;
  Gerador.wGrupo('/MDFe');

  if MDFe.procMDFe.nProt <> '' then
   begin
     xProtMDFe :=
           '<protMDFe versao="' + MDFeEnviMDFe + '">' +
             '<infProt>'+
               '<tpAmb>'+TpAmbToStr(MDFe.procMDFe.tpAmb)+'</tpAmb>'+
               '<verAplic>'+MDFe.procMDFe.verAplic+'</verAplic>'+
               '<chMDFe>'+MDFe.procMDFe.chMDFe+'</chMDFe>'+
               '<dhRecbto>'+FormatDateTime('yyyy-mm-dd"T"hh:nn:ss',MDFe.procMDFe.dhRecbto)+'</dhRecbto>'+
               '<nProt>'+MDFe.procMDFe.nProt+'</nProt>'+
               '<digVal>'+MDFe.procMDFe.digVal+'</digVal>'+
               '<cStat>'+IntToStr(MDFe.procMDFe.cStat)+'</cStat>'+
               '<xMotivo>'+MDFe.procMDFe.xMotivo+'</xMotivo>'+
             '</infProt>'+
           '</protMDFe>';

     Gerador.wTexto(xProtMDFe);
     Gerador.wGrupo('/mdfeProc');
   end;

  Gerador.gtAjustarRegistros(MDFe.infMDFe.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TMDFeW.GerarInfMDFe;
begin
  GerarIde;
  GerarEmit;
  GerarInfModal;
  GerarInfDoc;
  GerarTot;
  GerarLacres;
  GerarautXML;
  GerarInfAdic;
end;

procedure TMDFeW.GerarIde;
begin
  Gerador.wGrupo('ide', '#004');
  Gerador.wCampo(tcInt, '#005', 'cUF     ', 02, 02, 1, MDFe.ide.cUF, DSC_CUF);
  if not ValidarCodigoUF(MDFe.ide.cUF) then
    Gerador.wAlerta('#005', 'cUF', DSC_CUF, ERR_MSG_INVALIDO);

  Gerador.wCampo(tcStr, '#006', 'tpAmb   ', 01, 01, 1, tpAmbToStr(MDFe.Ide.tpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, '#007', 'tpEmit  ', 01, 01, 1, TpEmitenteToStr(MDFe.Ide.tpEmit), DSC_TPEMIT);
  Gerador.wCampo(tcInt, '#008', 'mod     ', 02, 02, 1, MDFe.ide.modelo, DSC_MOD);
  Gerador.wCampo(tcInt, '#009', 'serie   ', 01, 03, 1, MDFe.ide.serie, DSC_SERIE);
  Gerador.wCampo(tcInt, '#010', 'nMDF    ', 01, 09, 1, MDFe.ide.nMDF, DSC_NMDF);
  Gerador.wCampo(tcStr, '#011', 'cMDF    ', 08, 08, 1, IntToStrZero(RetornarCodigoNumerico(MDFe.infMDFe.ID, 2), 8), DSC_CMDF);
  Gerador.wCampo(tcInt, '#012', 'cDV     ', 01, 01, 1, MDFe.Ide.cDV, DSC_CDV);
  Gerador.wCampo(tcStr, '#013', 'modal   ', 02, 02, 1, ModalToStr(MDFe.Ide.modal), DSC_MODAL);
  Gerador.wCampo(tcDatHor, '#014', 'dhEmi', 19, 19, 1, MDFe.ide.dhEmi, DSC_DEMI);
  Gerador.wCampo(tcStr, '#015', 'tpEmis  ', 01, 01, 1, tpEmisToStr(MDFe.Ide.tpEmis), DSC_TPEMIS);
  Gerador.wCampo(tcStr, '#016', 'procEmi ', 01, 01, 1, procEmiToStr(MDFe.Ide.procEmi), DSC_PROCEMI);
  Gerador.wCampo(tcStr, '#017', 'verProc ', 01, 20, 1, MDFe.Ide.verProc, DSC_VERPROC);
  Gerador.wCampo(tcStr, '#018', 'UFIni   ', 02, 02, 1, MDFe.ide.UFIni, DSC_UF);
  if not ValidarUF(MDFe.ide.UFIni) then
    Gerador.wAlerta('#018', 'UFIni', DSC_UF, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcStr, '#019', 'UFFim   ', 02, 02, 1, MDFe.ide.UFFim, DSC_UF);
  if not ValidarUF(MDFe.ide.UFFim) then
    Gerador.wAlerta('#019', 'UFFim', DSC_UF, ERR_MSG_INVALIDO);

  GerarInfMunCarrega;
  GerarInfPercurso;
  Gerador.wCampo(tcDatHor, '#024a', 'dhIniViagem', 19, 19, 0, MDFe.ide.dhIniViagem, DSC_DHINIVIAGEM);

  Gerador.wGrupo('/ide');
end;

procedure TMDFeW.GerarinfMunCarrega;
var
  i: Integer;
begin
  for i := 0 to MDFe.Ide.infMunCarrega.Count - 1 do
  begin
    Gerador.wGrupo('infMunCarrega', '#020');
    Gerador.wCampo(tcInt, '#021', 'cMunCarrega', 07, 07, 1, MDFe.Ide.infMunCarrega[i].cMunCarrega, DSC_CMUNCARREGA);
    Gerador.wCampo(tcStr, '#022', 'xMunCarrega', 02, 60, 1, MDFe.Ide.infMunCarrega[i].xMunCarrega, DSC_XMUNCARREGA);
    Gerador.wGrupo('/infMunCarrega');
  end;
  if MDFe.Ide.infMunCarrega.Count > 50 then
   Gerador.wAlerta('#020', 'infMunCarrega', '', ERR_MSG_MAIOR_MAXIMO + '50');
end;

procedure TMDFeW.GerarinfPercurso;
var
  i: Integer;
begin
  for i := 0 to MDFe.Ide.infPercurso.Count - 1 do
  begin
    Gerador.wGrupo('infPercurso', '#023');
    Gerador.wCampo(tcStr, '#024', 'UFPer', 2, 2, 1, MDFe.Ide.infPercurso[i].UFPer, DSC_UFPER);
    Gerador.wGrupo('/infPercurso');
  end;
  if MDFe.Ide.infPercurso.Count > 25 then
   Gerador.wAlerta('#023', 'infPercurso', '', ERR_MSG_MAIOR_MAXIMO + '25');
end;

procedure TMDFeW.GerarEmit;
begin
  Gerador.wGrupo('emit', '#025');
  Gerador.wCampoCNPJ('#026', MDFe.Emit.CNPJ, CODIGO_BRASIL, True);
  Gerador.wCampo(tcStr, '#027', 'IE   ', 02, 14, 1, OnlyNumber(MDFe.Emit.IE), DSC_IE);
  if (FOpcoes.ValidarInscricoes)
   then if not ValidarIE(MDFe.Emit.IE, MDFe.Emit.enderEmit.UF) then
         Gerador.wAlerta('#027', 'IE', DSC_IE, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcStr, '#028', 'xNome', 02, 60, 1, MDFe.Emit.xNome, DSC_XNOME);
  Gerador.wCampo(tcStr, '#029', 'xFant', 01, 60, 0, MDFe.Emit.xFant, DSC_XFANT);

  GerarEnderEmit;
  Gerador.wGrupo('/emit');
end;

procedure TMDFeW.GerarEnderEmit;
var
  cMun: Integer;
  xMun: String;
  xUF: String;
begin
  AjustarMunicipioUF(xUF, xMun, cMun, CODIGO_BRASIL,
                                      MDFe.Emit.enderEmit.UF,
                                      MDFe.Emit.enderEmit.xMun,
                                      MDFe.Emit.EnderEmit.cMun);
  Gerador.wGrupo('enderEmit', '#030');
  Gerador.wCampo(tcStr, '#031', 'xLgr   ', 02, 60, 1, MDFe.Emit.enderEmit.xLgr, DSC_XLGR);
  Gerador.wCampo(tcStr, '#032', 'nro    ', 01, 60, 1, ExecutarAjusteTagNro(FOpcoes.FAjustarTagNro, MDFe.Emit.enderEmit.nro), DSC_NRO);
  Gerador.wCampo(tcStr, '#033', 'xCpl   ', 01, 60, 0, MDFe.Emit.enderEmit.xCpl, DSC_XCPL);
  Gerador.wCampo(tcStr, '#034', 'xBairro', 02, 60, 1, MDFe.Emit.enderEmit.xBairro, DSC_XBAIRRO);
  Gerador.wCampo(tcInt, '#035', 'cMun   ', 07, 07, 1, cMun, DSC_CMUN);
  if not ValidarMunicipio(MDFe.Emit.EnderEmit.cMun) then
    Gerador.wAlerta('#035', 'cMun', DSC_CMUN, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcStr, '#036', 'xMun   ', 01, 60, 1, xMun, DSC_XMUN);
  Gerador.wCampo(tcInt, '#037', 'CEP    ', 08, 08, 0, MDFe.Emit.enderEmit.CEP, DSC_CEP);
  Gerador.wCampo(tcStr, '#038', 'UF     ', 02, 02, 1, xUF, DSC_UF);
  if not ValidarUF(xUF) then
    Gerador.wAlerta('#038', 'UF', DSC_UF, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcStr, '#039', 'fone   ', 07, 12, 0, OnlyNumber(MDFe.Emit.EnderEmit.fone), DSC_FONE);
  Gerador.wCampo(tcStr, '#040', 'email  ', 01, 60, 0, MDFe.Emit.EnderEmit.email, DSC_EMAIL);
  Gerador.wGrupo('/enderEmit');
end;

procedure TMDFeW.GerarInfModal;
var
 versao: String;
begin
  versao := GetVersaoModalMDFe(VersaoDF, MDFe.Ide.modal);

  case StrToInt(ModalToStr(MDFe.Ide.modal)) of
   1: Gerador.wGrupo('infModal versaoModal="' + versao + '"', '#041');
   2: Gerador.wGrupo('infModal versaoModal="' + versao + '"', '#041');
   3: Gerador.wGrupo('infModal versaoModal="' + versao + '"', '#041');
   4: Gerador.wGrupo('infModal versaoModal="' + versao + '"', '#041');
  end;
  (*
  case StrToInt(ModalToStr(MDFe.Ide.modal)) of
   1: Gerador.wGrupo('infModal versaoModal="' + MDFeModalRodo  + '"', '#041');
   2: Gerador.wGrupo('infModal versaoModal="' + MDFeModalAereo + '"', '#041');
   3: Gerador.wGrupo('infModal versaoModal="' + MDFeModalAqua  + '"', '#041');
   4: Gerador.wGrupo('infModal versaoModal="' + MDFeModalFerro + '"', '#041');
  end;
  *)
  case StrToInt(ModalToStr(MDFe.Ide.modal)) of
   1: GerarRodo;   // Informa��es do Modal Rodovi�rio
   2: GerarAereo;  // Informa��es do Modal A�reo
   3: GerarAquav;  // Informa��es do Modal Aquavi�rio
   4: GerarFerrov; // Informa��es do Modal Ferrovi�rio
  end;
  Gerador.wGrupo('/infModal');
end;

procedure TMDFeW.GerarRodo;
var
  i: Integer;
begin
  Gerador.wGrupo('rodo', '#01');
  Gerador.wCampo(tcStr, '#02', 'RNTRC', 08, 08, 0, OnlyNumber(MDFe.Rodo.RNTRC), DSC_RNTRC);
  Gerador.wCampo(tcStr, '#03', 'CIOT ', 12, 12, 0, MDFe.Rodo.CIOT, DSC_CIOT);

  Gerador.wGrupo('veicTracao', '#04');
  Gerador.wCampo(tcStr, '#05',  'cInt   ', 01, 10, 0, MDFe.Rodo.veicTracao.cInt, DSC_CINTV);
  Gerador.wCampo(tcStr, '#06',  'placa  ', 01, 07, 1, MDFe.Rodo.veicTracao.placa, DSC_PLACA);
  Gerador.wCampo(tcStr, '#06a', 'RENAVAM', 09, 11, 0, MDFe.Rodo.veicTracao.RENAVAM, DSC_RENAVAM);
  Gerador.wCampo(tcInt, '#07',  'tara   ', 01, 06, 1, MDFe.Rodo.veicTracao.tara, DSC_TARA);
  Gerador.wCampo(tcInt, '#08',  'capKG  ', 01, 06, 1, MDFe.Rodo.veicTracao.capKG, DSC_CAPKG);
  Gerador.wCampo(tcInt, '#09',  'capM3  ', 01, 03, 1, MDFe.Rodo.veicTracao.capM3, DSC_CAPM3);

  if (MDFe.Rodo.veicTracao.Prop.CNPJCPF <> '') or
     (MDFe.Rodo.veicTracao.Prop.RNTRC <> '') or
     (MDFe.Rodo.veicTracao.Prop.xNome <> '') then
  begin
    Gerador.wGrupo('prop', '#32');

//    if VersaoDF = ve100
//     then Gerador.wCampo(tcStr, '#35', 'RNTRC ', 08, 08, 1, SomenteNumeros(MDFe.Rodo.veicTracao.Prop.RNTRC), DSC_RNTRC)
//     else begin
      Gerador.wCampoCNPJCPF('#11', '#12', MDFe.Rodo.veicTracao.Prop.CNPJCPF, CODIGO_BRASIL);
      Gerador.wCampo(tcStr, '#13', 'RNTRC ', 08, 08, 1, OnlyNumber(MDFe.Rodo.veicTracao.Prop.RNTRC), DSC_RNTRC);
      Gerador.wCampo(tcStr, '#14', 'xNome ', 02, 60, 1, MDFe.Rodo.veicTracao.Prop.xNome, DSC_XNOME);

      if MDFe.Rodo.veicTracao.Prop.IE <> '' then
      begin
        if MDFe.Rodo.veicTracao.Prop.IE = 'ISENTO' then
          Gerador.wCampo(tcStr, '#15', 'IE ', 00, 14, 1, MDFe.Rodo.veicTracao.Prop.IE, DSC_IE)
        else
          Gerador.wCampo(tcStr, '#15', 'IE ', 02, 14, 1, OnlyNumber(MDFe.Rodo.veicTracao.Prop.IE), DSC_IE);
        if (FOpcoes.ValidarInscricoes) then
          if not ValidarIE(MDFe.Rodo.veicTracao.Prop.IE, MDFe.Rodo.veicTracao.Prop.UF) then
            Gerador.wAlerta('#15', 'IE', DSC_IE, ERR_MSG_INVALIDO);
        Gerador.wCampo(tcStr, '#16', 'UF     ', 02, 02, 1, MDFe.Rodo.veicTracao.Prop.UF, DSC_CUF);
        if not ValidarUF(MDFe.Rodo.veicTracao.Prop.UF) then
          Gerador.wAlerta('#16', 'UF', DSC_UF, ERR_MSG_INVALIDO);
      end;

      Gerador.wCampo(tcStr, '#17', 'tpProp ', 01, 01, 1, TpPropToStr(MDFe.Rodo.veicTracao.Prop.tpProp), DSC_TPPROP);
//     end;

    Gerador.wGrupo('/prop');
  end;

  for i := 0 to MDFe.rodo.veicTracao.condutor.Count - 1 do
  begin
    Gerador.wGrupo('condutor', '#18');
    Gerador.wCampo(tcStr, '#19', 'xNome', 02, 60, 1, MDFe.rodo.veicTracao.condutor[i].xNome, DSC_XNOME);
    Gerador.wCampo(tcStr, '#20', 'CPF  ', 11, 11, 1, MDFe.rodo.veicTracao.condutor[i].CPF, DSC_CPF);
    Gerador.wGrupo('/condutor');
  end;
  if MDFe.rodo.veicTracao.condutor.Count > 10 then
   Gerador.wAlerta('#18', 'condutor', '', ERR_MSG_MAIOR_MAXIMO + '10');

//   if VersaoDF = ve100a
//    then begin
     Gerador.wCampo(tcStr, '#21', 'tpRod', 02, 02, 1, TpRodadoToStr(MDFe.Rodo.veicTracao.tpRod), '');
     Gerador.wCampo(tcStr, '#22', 'tpCar', 02, 02, 1, TpCarroceriaToStr(MDFe.Rodo.veicTracao.tpCar), '');
     Gerador.wCampo(tcStr, '#23', 'UF   ', 02, 02, 1, MDFe.Rodo.veicTracao.UF, DSC_CUF);
//    end;

  Gerador.wGrupo('/veicTracao');

  for i := 0 to MDFe.rodo.veicReboque.Count - 1 do
  begin
    Gerador.wGrupo('veicReboque', '#24');
    Gerador.wCampo(tcStr, '#25',  'cInt   ', 01, 10, 0, MDFe.Rodo.veicReboque[i].cInt, DSC_CINTV);
    Gerador.wCampo(tcStr, '#26',  'placa  ', 01, 07, 1, MDFe.Rodo.veicReboque[i].placa, DSC_PLACA);
    Gerador.wCampo(tcStr, '#26a', 'RENAVAM', 09, 11, 0, MDFe.Rodo.veicReboque[i].RENAVAM, DSC_RENAVAM);
    Gerador.wCampo(tcInt, '#27',  'tara   ', 01, 06, 1, MDFe.Rodo.veicReboque[i].tara, DSC_TARA);
    Gerador.wCampo(tcInt, '#28',  'capKG  ', 01, 06, 1, MDFe.Rodo.veicReboque[i].capKG, DSC_CAPKG);
    Gerador.wCampo(tcInt, '#29',  'capM3  ', 01, 03, 1, MDFe.Rodo.veicReboque[i].capM3, DSC_CAPM3);

    if (MDFe.Rodo.veicReboque[i].Prop.CNPJCPF <> '') or
       (MDFe.Rodo.veicReboque[i].Prop.RNTRC <> '') or
       (MDFe.Rodo.veicReboque[i].Prop.xNome <> '') then
    begin
      Gerador.wGrupo('prop', '#30');

//      if VersaoDF = ve100
//       then Gerador.wCampo(tcStr, '#35', 'RNTRC ', 08, 08, 1, SomenteNumeros(MDFe.Rodo.veicReboque[i].Prop.RNTRC), DSC_RNTRC)
//       else begin
        Gerador.wCampoCNPJCPF('#31', '#32', MDFe.Rodo.veicReboque[i].Prop.CNPJCPF, CODIGO_BRASIL);
        Gerador.wCampo(tcStr, '#33', 'RNTRC ', 08, 08, 1, OnlyNumber(MDFe.Rodo.veicReboque[i].Prop.RNTRC), DSC_RNTRC);
        Gerador.wCampo(tcStr, '#34', 'xNome ', 02, 60, 1, MDFe.Rodo.veicReboque[i].Prop.xNome, DSC_XNOME);

        if MDFe.Rodo.veicReboque[i].Prop.IE <> ''
         then begin
          if MDFe.Rodo.veicReboque[i].Prop.IE = 'ISENTO'
           then Gerador.wCampo(tcStr, '#35', 'IE ', 00, 14, 1, MDFe.Rodo.veicTracao.Prop.IE, DSC_IE)
           else Gerador.wCampo(tcStr, '#35', 'IE ', 02, 14, 1, OnlyNumber(MDFe.Rodo.veicReboque[i].Prop.IE), DSC_IE);
          if (FOpcoes.ValidarInscricoes)
           then if not ValidarIE(MDFe.Rodo.veicReboque[i].Prop.IE, MDFe.Rodo.veicReboque[i].Prop.UF) then
            Gerador.wAlerta('#35', 'IE', DSC_IE, ERR_MSG_INVALIDO);
          Gerador.wCampo(tcStr, '#36', 'UF     ', 02, 02, 1, MDFe.Rodo.veicReboque[i].Prop.UF, DSC_CUF);
          if not ValidarUF(MDFe.Rodo.veicReboque[i].Prop.UF) then
           Gerador.wAlerta('#36', 'UF', DSC_UF, ERR_MSG_INVALIDO);
         end;

        Gerador.wCampo(tcStr, '#37', 'tpProp ', 01, 01, 1, TpPropToStr(MDFe.Rodo.veicReboque[i].Prop.tpProp), DSC_TPPROP);
//      end;

      Gerador.wGrupo('/prop');
    end;
//    if VersaoDF = ve100a then
//    begin
      Gerador.wCampo(tcStr, '#38', 'tpCar   ', 02, 02, 1, TpCarroceriaToStr(MDFe.Rodo.veicReboque[i].tpCar), '');
      Gerador.wCampo(tcStr, '#39', 'UF      ', 02, 02, 1, MDFe.Rodo.veicReboque[i].UF, DSC_CUF);
//    end;

    Gerador.wGrupo('/veicReboque');
  end;
  if MDFe.rodo.veicReboque.Count > 3 then
   Gerador.wAlerta('#15', 'veicReboque', '', ERR_MSG_MAIOR_MAXIMO + '3');

  if MDFe.rodo.valePed.disp.Count>0
   then begin
    Gerador.wGrupo('valePed', '#23');

    for i := 0 to MDFe.rodo.valePed.disp.Count - 1 do
    begin
      Gerador.wGrupo('disp', '#24');
      Gerador.wCampo(tcStr, '#25', 'CNPJForn', 14, 14, 1, MDFe.Rodo.valePed.disp[i].CNPJForn, DSC_CNPJFORN);
      Gerador.wCampo(tcStr, '#26', 'CNPJPg  ', 14, 14, 0, MDFe.Rodo.valePed.disp[i].CNPJPg, DSC_CNPJPG);
      Gerador.wCampo(tcStr, '#27', 'nCompra ', 01, 20, 1, MDFe.Rodo.valePed.disp[i].nCompra, DSC_NCOMPRA);
      Gerador.wGrupo('/disp');
    end;
    if MDFe.rodo.valePed.disp.Count > 990 then
     Gerador.wAlerta('#24', 'disp', '', ERR_MSG_MAIOR_MAXIMO + '990');

    Gerador.wGrupo('/valePed');
   end;

  Gerador.wCampo(tcStr, '#45', 'codAgPorto', 01, 16, 0, MDFe.Rodo.codAgPorto, DSC_CODAGPORTO);

  Gerador.wGrupo('/rodo');
end;

procedure TMDFeW.GerarAereo;
begin
  Gerador.wGrupo('aereo', '#01');
  Gerador.wCampo(tcInt, '#02', 'nac    ', 01, 04, 1, MDFe.Aereo.nac, DSC_NAC);
  Gerador.wCampo(tcInt, '#03', 'matr   ', 01, 06, 1, MDFe.Aereo.matr, DSC_MATR);
  Gerador.wCampo(tcStr, '#04', 'nVoo   ', 05, 09, 1, MDFe.Aereo.nVoo, DSC_NVOO);
  Gerador.wCampo(tcStr, '#05', 'cAerEmb', 03, 04, 1, MDFe.Aereo.cAerEmb, DSC_CAEREMB);
  Gerador.wCampo(tcStr, '#06', 'cAerDes', 03, 04, 1, MDFe.Aereo.cAerDes, DSC_CAERDES);
  Gerador.wCampo(tcDat, '#07', 'dVoo   ', 10, 10, 0, MDFe.Aereo.dVoo, DSC_DVOO);
  Gerador.wGrupo('/aereo');
end;

procedure TMDFeW.GerarAquav;
var
  i: Integer;
begin
  Gerador.wGrupo('aquav', '#01');
  Gerador.wCampo(tcStr, '#02', 'CNPJAgeNav', 14, 14, 1, MDFe.aquav.CNPJAgeNav, DSC_CNPJAGENAV);
  Gerador.wCampo(tcStr, '#03', 'tpEmb     ', 02, 02, 1, MDFe.aquav.tpEmb, DSC_TPEMB);
  Gerador.wCampo(tcStr, '#04', 'cEmbar    ', 01, 10, 1, MDFe.aquav.cEmbar, DSC_CEMBAR);
  Gerador.wCampo(tcStr, '#05', 'xEmbar    ', 01, 60, 1, MDFe.aquav.xEmbar, DSC_XEMBAR);
  Gerador.wCampo(tcStr, '#05', 'nViag     ', 01, 10, 1, MDFe.aquav.nViagem, DSC_NVIAG);
  Gerador.wCampo(tcStr, '#06', 'cPrtEmb   ', 01, 05, 1, MDFe.aquav.cPrtEmb, DSC_CPRTEMB);
  Gerador.wCampo(tcStr, '#07', 'cPrtDest  ', 01, 05, 1, MDFe.aquav.cPrtDest, DSC_CPRTDEST);

  for i := 0 to MDFe.aquav.infTermCarreg.Count - 1 do
  begin
    Gerador.wGrupo('infTermCarreg', '#08');
    Gerador.wCampo(tcStr, '#09', 'cTermCarreg', 01, 08, 1, MDFe.aquav.infTermCarreg[i].cTermCarreg, DSC_CTERMCARREG);
    Gerador.wCampo(tcStr, '#09', 'xTermCarreg', 01, 60, 1, MDFe.aquav.infTermCarreg[i].xTermCarreg, DSC_XTERMCARREG);
    Gerador.wGrupo('/infTermCarreg');
  end;
  if MDFe.aquav.infTermCarreg.Count > 5 then
   Gerador.wAlerta('#08', 'infTermCarreg', '', ERR_MSG_MAIOR_MAXIMO + '5');

  for i := 0 to MDFe.aquav.infTermDescarreg.Count - 1 do
  begin
    Gerador.wGrupo('infTermDescarreg', '#10');
    Gerador.wCampo(tcStr, '#11', 'cTermDescarreg', 01, 08, 1, MDFe.aquav.infTermDescarreg[i].cTermDescarreg, DSC_CTERMDESCAR);
    Gerador.wCampo(tcStr, '#11', 'xTermDescarreg', 01, 60, 1, MDFe.aquav.infTermDescarreg[i].xTermDescarreg, DSC_XTERMDESCAR);
    Gerador.wGrupo('/infTermDescarreg');
  end;
  if MDFe.aquav.infTermDescarreg.Count > 5 then
   Gerador.wAlerta('#10', 'infTermDescarreg', '', ERR_MSG_MAIOR_MAXIMO + '5');

  for i := 0 to MDFe.aquav.infEmbComb.Count - 1 do
  begin
    Gerador.wGrupo('infEmbComb', '#12');
    Gerador.wCampo(tcStr, '#13', 'cEmbComb', 01, 10, 1, MDFe.aquav.infEmbComb[i].cEmbComb, DSC_CEMBCOMB);
    Gerador.wGrupo('/infEmbComb');
  end;
  if MDFe.aquav.infEmbComb.Count > 30 then
   Gerador.wAlerta('#12', 'infEmbComb', '', ERR_MSG_MAIOR_MAXIMO + '30');

  for i := 0 to MDFe.aquav.infUnidCargaVazia.Count - 1 do
  begin
    Gerador.wGrupo('infUnidCargaVazia', '#017');
    Gerador.wCampo(tcStr, '#018', 'idUnidCargaVazia', 01, 20, 1, MDFe.aquav.infUnidCargaVazia[i].idUnidCargaVazia, DSC_IDUNIDCARGA);
    Gerador.wCampo(tcStr, '#019', 'tpUnidCargaVazia', 01, 01, 1, UnidCargaToStr(MDFe.aquav.infUnidCargaVazia[i].tpUnidCargaVazia), DSC_TPUNIDCARGA);
    Gerador.wGrupo('/infUnidCargaVazia');
  end;
  if MDFe.aquav.infUnidCargaVazia.Count > 999 then
   Gerador.wAlerta('#17', 'infUnidCargaVazia', '', ERR_MSG_MAIOR_MAXIMO + '999');

  Gerador.wGrupo('/aquav');
end;

procedure TMDFeW.GerarFerrov;
var
  i: Integer;
begin
  Gerador.wGrupo('ferrov', '#01');

  Gerador.wGrupo('trem', '#02');
  Gerador.wCampo(tcStr, '#03', 'xPref    ', 01, 10, 1, MDFe.ferrov.xPref, DSC_XPREF);
  Gerador.wCampo(tcDatHor, '#04', 'dhTrem', 19, 19, 0, MDFe.ferrov.dhTrem, DSC_DHTREM);
  Gerador.wCampo(tcStr, '#05', 'xOri     ', 01, 03, 1, MDFe.ferrov.xOri, DSC_XORI);
  Gerador.wCampo(tcStr, '#06', 'xDest    ', 01, 03, 1, MDFe.ferrov.xDest, DSC_XDEST);
  Gerador.wCampo(tcInt, '#07', 'qVag     ', 01, 03, 1, MDFe.ferrov.qVag, DSC_QVAG);
  Gerador.wGrupo('/trem');

  for i := 0 to MDFe.ferrov.vag.Count - 1 do
  begin
    Gerador.wGrupo('vag', '#08');
    Gerador.wCampo(tcStr, '#09', 'serie', 3, 3, 1, MDFe.ferrov.vag[i].serie, DSC_NSERIE);
    Gerador.wCampo(tcInt, '#10', 'nVag ', 1, 8, 1, MDFe.ferrov.vag[i].nVag, DSC_NVAG);
    Gerador.wCampo(tcInt, '#11', 'nSeq ', 1, 3, 0, MDFe.ferrov.vag[i].nSeq, DSC_NSEQ);
    Gerador.wCampo(tcDe3, '#12', 'TU   ', 1, 7, 1, MDFe.ferrov.vag[i].TU, DSC_TU);
    Gerador.wGrupo('/vag');
  end;
  if MDFe.ferrov.vag.Count > 990 then
   Gerador.wAlerta('#08', 'vag', '', ERR_MSG_MAIOR_MAXIMO + '990');

  Gerador.wGrupo('/ferrov');
end;

procedure TMDFeW.GerarInfDoc;
var
  i, j, k, l, m: Integer;
begin
  Gerador.wGrupo('infDoc', '#040');

  for i := 0 to MDFe.infDoc.infMunDescarga.Count - 1 do
  begin
    Gerador.wGrupo('infMunDescarga', '#045');
    Gerador.wCampo(tcInt, '#046', 'cMunDescarga', 07, 07, 1, MDFe.infDoc.infMunDescarga[i].cMunDescarga, DSC_CMUN);
    if not ValidarMunicipio(MDFe.infDoc.infMunDescarga[i].cMunDescarga) then
      Gerador.wAlerta('#045', 'cMunDescarga', DSC_CMUN, ERR_MSG_INVALIDO);
    Gerador.wCampo(tcStr, '#046', 'xMunDescarga', 02, 60, 1, MDFe.infDoc.infMunDescarga[i].xMunDescarga, DSC_XMUN);

    // Alterado por Italo em 21/03/2013
    // Conforme NT 2013/001
    case MDFe.Ide.tpEmit of
     // Se Tipo de Emitente for Prestador de Servi�o de Transporte
     // s� pode relacionar os grupos de documentos CT-e e CT
     teTransportadora:
       begin
         for j := 0 to MDFe.infDoc.infMunDescarga[i].infCTe.Count - 1 do
         begin
           Gerador.wGrupo('infCTe', '#048');
           Gerador.wCampo(tcEsp, '#049', 'chCTe      ', 44, 44, 1, OnlyNumber(MDFe.infDoc.infMunDescarga[i].infCTe[j].chCTe), DSC_REFNFE);
           if OnlyNumber(MDFe.infDoc.infMunDescarga[i].infCTe[j].chCTe) <> '' then
            if not ValidarChave('NFe' + OnlyNumber(MDFe.infDoc.infMunDescarga[i].infCTe[j].chCTe)) then
           Gerador.wAlerta('#049', 'chCTe', DSC_REFNFE, ERR_MSG_INVALIDO);
           Gerador.wCampo(tcStr, '#050', 'SegCodBarra', 44, 44, 0, MDFe.infDoc.infMunDescarga[i].infCTe[j].SegCodBarra, DSC_SEGCODBARRA);

           // Implementado conforme NT 2013/002
           for k := 0 to MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp.Count - 1 do
           begin
             Gerador.wGrupo('infUnidTransp', '#051');
             Gerador.wCampo(tcStr, '#052', 'tpUnidTransp', 01, 01, 1, UnidTranspToStr(MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].tpUnidTransp), DSC_TPUNIDTRANSP);
             Gerador.wCampo(tcStr, '#053', 'idUnidTransp', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].idUnidTransp, DSC_IDUNIDTRANSP);

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].lacUnidTransp.Count - 1 do
             begin
               Gerador.wGrupo('lacUnidTransp', '#054');
               Gerador.wCampo(tcStr, '#055', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].lacUnidTransp[l].nLacre, DSC_NLACRE);
               Gerador.wGrupo('/lacUnidTransp');
             end;

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga.Count - 1 do
             begin
               Gerador.wGrupo('infUnidCarga', '#056');
               Gerador.wCampo(tcStr, '#057', 'tpUnidCarga', 01, 01, 1, UnidCargaToStr(MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga[l].tpUnidCarga), DSC_TPUNIDCARGA);
               Gerador.wCampo(tcStr, '#058', 'idUnidCarga', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga[l].idUnidCarga, DSC_IDUNIDCARGA);

               for m := 0 to MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga.Count - 1 do
               begin
                 Gerador.wGrupo('lacUnidCarga', '#059');
                 Gerador.wCampo(tcStr, '#060', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga[m].nLacre, DSC_NLACRE);
                 Gerador.wGrupo('/lacUnidCarga');
               end;
               Gerador.wCampo(tcDe2, '#061', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].infUnidCarga[l].qtdRat, DSC_QTDRAT);

               Gerador.wGrupo('/infUnidCarga');
             end;
             Gerador.wCampo(tcDe2, '#062', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infCTe[j].infUnidTransp[k].qtdRat, DSC_QTDRAT);

             Gerador.wGrupo('/infUnidTransp');
           end;

           Gerador.wGrupo('/infCTe');
         end;
         if MDFe.infDoc.infMunDescarga[i].infCTe.Count > 4000 then
          Gerador.wAlerta('#048', 'infCTe', '', ERR_MSG_MAIOR_MAXIMO + '4000');

         for j := 0 to MDFe.infDoc.infMunDescarga[i].infCT.Count - 1 do
         begin
           Gerador.wGrupo('infCT', '#051');
           Gerador.wCampo(tcStr, '#052', 'nCT   ', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].nCT, DSC_NCT);
           Gerador.wCampo(tcInt, '#053', 'serie ', 01, 03, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].serie, DSC_SERIE);
           Gerador.wCampo(tcInt, '#054', 'subser', 01, 02, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].subser, DSC_SUBSERIE);
           Gerador.wCampo(tcDat, '#055', 'dEmi  ', 10, 10, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].dEmi, DSC_DEMI);
           Gerador.wCampo(tcDe2, '#056', 'vCarga', 01, 15, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].vCarga, DSC_VDOC);

           // Implementado conforme NT 2013/002
           for k := 0 to MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp.Count - 1 do
           begin
             Gerador.wGrupo('infUnidTransp', '#051');
             Gerador.wCampo(tcStr, '#052', 'tpUnidTransp', 01, 01, 1, UnidTranspToStr(MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].tpUnidTransp), DSC_TPUNIDTRANSP);
             Gerador.wCampo(tcStr, '#053', 'idUnidTransp', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].idUnidTransp, DSC_IDUNIDTRANSP);

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].lacUnidTransp.Count - 1 do
             begin
               Gerador.wGrupo('lacUnidTransp', '#054');
               Gerador.wCampo(tcStr, '#055', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].lacUnidTransp[l].nLacre, DSC_NLACRE);
               Gerador.wGrupo('/lacUnidTransp');
             end;

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga.Count - 1 do
             begin
               Gerador.wGrupo('infUnidCarga', '#056');
               Gerador.wCampo(tcStr, '#057', 'tpUnidCarga', 01, 01, 1, UnidCargaToStr(MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga[l].tpUnidCarga), DSC_TPUNIDCARGA);
               Gerador.wCampo(tcStr, '#058', 'idUnidCarga', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga[l].idUnidCarga, DSC_IDUNIDCARGA);

               for m := 0 to MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga.Count - 1 do
               begin
                 Gerador.wGrupo('lacUnidCarga', '#059');
                 Gerador.wCampo(tcStr, '#060', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga[m].nLacre, DSC_NLACRE);
                 Gerador.wGrupo('/lacUnidCarga');
               end;
               Gerador.wCampo(tcDe2, '#061', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].infUnidCarga[l].qtdRat, DSC_QTDRAT);

               Gerador.wGrupo('/infUnidCarga');
             end;
             Gerador.wCampo(tcDe2, '#062', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infCT[j].infUnidTransp[k].qtdRat, DSC_QTDRAT);

             Gerador.wGrupo('/infUnidTransp');
           end;

           Gerador.wGrupo('/infCT');
         end;
         if MDFe.infDoc.infMunDescarga[i].infCT.Count > 4000 then
          Gerador.wAlerta('#051', 'infCT', '', ERR_MSG_MAIOR_MAXIMO + '4000');
       end;
     // Se Tipo de Emitente for Transporte de Carga Pr�pria
     // s� pode relacionar os grupos de documentos NF-e e NT
     // Obs: � considerado Emitente de Transporte de Carga Pr�pria os
     //      Emitentes de NF-e e transportadoras quando estiverem fazendo
     //      transporte de carga pr�pria.
     teTranspCargaPropria:
       begin
         for j := 0 to MDFe.infDoc.infMunDescarga[i].infNFe.Count - 1 do
         begin
           Gerador.wGrupo('infNFe', '#057');
           Gerador.wCampo(tcEsp, '#058', 'chNFe      ', 44, 44, 1, OnlyNumber(MDFe.infDoc.infMunDescarga[i].infNFe[j].chNFe), DSC_REFNFE);
           if OnlyNumber(MDFe.infDoc.infMunDescarga[i].infNFe[j].chNFe) <> '' then
            if not ValidarChave('NFe' + OnlyNumber(MDFe.infDoc.infMunDescarga[i].infNFe[j].chNFe)) then
             Gerador.wAlerta('#058', 'chNFe', DSC_REFNFE, ERR_MSG_INVALIDO);
           Gerador.wCampo(tcStr, '#059', 'SegCodBarra', 44, 44, 0, MDFe.infDoc.infMunDescarga[i].infNFe[j].SegCodBarra, DSC_SEGCODBARRA);

           // Implementado conforme NT 2013/002
           for k := 0 to MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp.Count - 1 do
           begin
             Gerador.wGrupo('infUnidTransp', '#051');
             Gerador.wCampo(tcStr, '#052', 'tpUnidTransp', 01, 01, 1, UnidTranspToStr(MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].tpUnidTransp), DSC_TPUNIDTRANSP);
             Gerador.wCampo(tcStr, '#053', 'idUnidTransp', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].idUnidTransp, DSC_IDUNIDTRANSP);

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].lacUnidTransp.Count - 1 do
             begin
               Gerador.wGrupo('lacUnidTransp', '#054');
               Gerador.wCampo(tcStr, '#055', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].lacUnidTransp[l].nLacre, DSC_NLACRE);
               Gerador.wGrupo('/lacUnidTransp');
             end;

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga.Count - 1 do
             begin
               Gerador.wGrupo('infUnidCarga', '#056');
               Gerador.wCampo(tcStr, '#057', 'tpUnidCarga', 01, 01, 1, UnidCargaToStr(MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga[l].tpUnidCarga), DSC_TPUNIDCARGA);
               Gerador.wCampo(tcStr, '#058', 'idUnidCarga', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga[l].idUnidCarga, DSC_IDUNIDCARGA);

               for m := 0 to MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga.Count - 1 do
               begin
                 Gerador.wGrupo('lacUnidCarga', '#059');
                 Gerador.wCampo(tcStr, '#060', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga[m].nLacre, DSC_NLACRE);
                 Gerador.wGrupo('/lacUnidCarga');
               end;
               Gerador.wCampo(tcDe2, '#061', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].infUnidCarga[l].qtdRat, DSC_QTDRAT);

               Gerador.wGrupo('/infUnidCarga');
             end;
             Gerador.wCampo(tcDe2, '#062', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infNFe[j].infUnidTransp[k].qtdRat, DSC_QTDRAT);

             Gerador.wGrupo('/infUnidTransp');
           end;

           Gerador.wGrupo('/infNFe');
         end;
         if MDFe.infDoc.infMunDescarga[i].infNFe.Count > 4000 then
          Gerador.wAlerta('#057', 'infNFe', '', ERR_MSG_MAIOR_MAXIMO + '4000');

         for j := 0 to MDFe.infDoc.infMunDescarga[i].infNF.Count - 1 do
         begin
           Gerador.wGrupo('infNF', '#060');
           Gerador.wCampoCNPJ('#061', MDFe.infDoc.infMunDescarga[i].infNF[j].CNPJ, CODIGO_BRASIL, True);
           Gerador.wCampo(tcStr, '#062', 'UF   ', 02, 02, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].UF, DSC_IE);
           Gerador.wCampo(tcStr, '#063', 'nNF  ', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].nNF, DSC_NNF);
           Gerador.wCampo(tcInt, '#064', 'serie', 01, 03, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].serie, DSC_SERIE);
           Gerador.wCampo(tcDat, '#065', 'dEmi ', 10, 10, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].dEmi, DSC_DEMI);
           Gerador.wCampo(tcDe2, '#066', 'vNF  ', 01, 15, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].vNF, DSC_VDOC);
           Gerador.wCampo(tcInt, '#067', 'PIN  ', 02, 09, 0, MDFe.infDoc.infMunDescarga[i].infNF[j].PIN, DSC_PIN);

           // Implementado conforme NT 2013/002
           for k := 0 to MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp.Count - 1 do
           begin
             Gerador.wGrupo('infUnidTransp', '#051');
             Gerador.wCampo(tcStr, '#052', 'tpUnidTransp', 01, 01, 1, UnidTranspToStr(MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].tpUnidTransp), DSC_TPUNIDTRANSP);
             Gerador.wCampo(tcStr, '#053', 'idUnidTransp', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].idUnidTransp, DSC_IDUNIDTRANSP);

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].lacUnidTransp.Count - 1 do
             begin
               Gerador.wGrupo('lacUnidTransp', '#054');
               Gerador.wCampo(tcStr, '#055', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].lacUnidTransp[l].nLacre, DSC_NLACRE);
               Gerador.wGrupo('/lacUnidTransp');
             end;

             for l := 0 to MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga.Count - 1 do
             begin
               Gerador.wGrupo('infUnidCarga', '#056');
               Gerador.wCampo(tcStr, '#057', 'tpUnidCarga', 01, 01, 1, UnidCargaToStr(MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga[l].tpUnidCarga), DSC_TPUNIDCARGA);
               Gerador.wCampo(tcStr, '#058', 'idUnidCarga', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga[l].idUnidCarga, DSC_IDUNIDCARGA);

               for m := 0 to MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga.Count - 1 do
               begin
                 Gerador.wGrupo('lacUnidCarga', '#059');
                 Gerador.wCampo(tcStr, '#060', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga[m].nLacre, DSC_NLACRE);
                 Gerador.wGrupo('/lacUnidCarga');
               end;
               Gerador.wCampo(tcDe2, '#061', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].infUnidCarga[l].qtdRat, DSC_QTDRAT);

               Gerador.wGrupo('/infUnidCarga');
             end;
             Gerador.wCampo(tcDe2, '#062', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infNF[j].infUnidTransp[k].qtdRat, DSC_QTDRAT);

             Gerador.wGrupo('/infUnidTransp');
           end;

           Gerador.wGrupo('/infNF');
         end;
         if MDFe.infDoc.infMunDescarga[i].infNF.Count > 4000 then
          Gerador.wAlerta('#060', 'infNF', '', ERR_MSG_MAIOR_MAXIMO + '4000');
       end;
    end;

    if MDFe.Ide.modal = moAquaviario
     then begin
       for j := 0 to MDFe.infDoc.infMunDescarga[i].infMDFeTransp.Count - 1 do
       begin
         Gerador.wGrupo('infMDFeTransp', '#057');
         Gerador.wCampo(tcEsp, '#058', 'chMDFe      ', 44, 44, 1, OnlyNumber(MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].chMDFe), DSC_REFNFE);
         if OnlyNumber(MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].chMDFe) <> '' then
          if not ValidarChave('NFe' + OnlyNumber(MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].chMDFe)) then
           Gerador.wAlerta('#058', 'chMDFe', DSC_REFNFE, ERR_MSG_INVALIDO);

         for k := 0 to MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp.Count - 1 do
         begin
           Gerador.wGrupo('infUnidTransp', '#051');
           Gerador.wCampo(tcStr, '#052', 'tpUnidTransp', 01, 01, 1, UnidTranspToStr(MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].tpUnidTransp), DSC_TPUNIDTRANSP);
           Gerador.wCampo(tcStr, '#053', 'idUnidTransp', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].idUnidTransp, DSC_IDUNIDTRANSP);

           for l := 0 to MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].lacUnidTransp.Count - 1 do
           begin
             Gerador.wGrupo('lacUnidTransp', '#054');
             Gerador.wCampo(tcStr, '#055', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].lacUnidTransp[l].nLacre, DSC_NLACRE);
             Gerador.wGrupo('/lacUnidTransp');
           end;

           for l := 0 to MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga.Count - 1 do
           begin
             Gerador.wGrupo('infUnidCarga', '#056');
             Gerador.wCampo(tcStr, '#057', 'tpUnidCarga', 01, 01, 1, UnidCargaToStr(MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga[l].tpUnidCarga), DSC_TPUNIDCARGA);
             Gerador.wCampo(tcStr, '#058', 'idUnidCarga', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga[l].idUnidCarga, DSC_IDUNIDCARGA);

             for m := 0 to MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga.Count - 1 do
             begin
               Gerador.wGrupo('lacUnidCarga', '#059');
               Gerador.wCampo(tcStr, '#060', 'nLacre', 01, 20, 1, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga[l].lacUnidCarga[m].nLacre, DSC_NLACRE);
               Gerador.wGrupo('/lacUnidCarga');
             end;
             Gerador.wCampo(tcDe2, '#061', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].infUnidCarga[l].qtdRat, DSC_QTDRAT);

             Gerador.wGrupo('/infUnidCarga');
           end;
           Gerador.wCampo(tcDe2, '#062', 'qtdRat', 01, 05, 0, MDFe.infDoc.infMunDescarga[i].infMDFeTransp[j].infUnidTransp[k].qtdRat, DSC_QTDRAT);

           Gerador.wGrupo('/infUnidTransp');
         end;

         Gerador.wGrupo('/infMDFeTransp');
       end;
       if MDFe.infDoc.infMunDescarga[i].infMDFeTransp.Count > 4000 then
        Gerador.wAlerta('#057', 'infMDFeTransp', '', ERR_MSG_MAIOR_MAXIMO + '4000');
     end;

    Gerador.wGrupo('/infMunDescarga');
  end;
  if MDFe.infDoc.infMunDescarga.Count > 100 then
   Gerador.wAlerta('#045', 'infMunDescarga', '', ERR_MSG_MAIOR_MAXIMO + '100');

  Gerador.wGrupo('/infDoc');
end;

procedure TMDFeW.GerarTot;
begin
  Gerador.wGrupo('tot', '#068');
  Gerador.wCampo(tcInt, '#069', 'qCTe  ', 01, 04, 0, MDFe.tot.qCTe, DSC_QCTE);
  Gerador.wCampo(tcInt, '#070', 'qCT   ', 01, 04, 0, MDFe.tot.qCT, DSC_QCT);
  Gerador.wCampo(tcInt, '#071', 'qNFe  ', 01, 04, 0, MDFe.tot.qNFe, DSC_QNFE);
  Gerador.wCampo(tcInt, '#072', 'qNF   ', 01, 04, 0, MDFe.tot.qNF, DSC_QNF);
  Gerador.wCampo(tcInt, '#072', 'qMDFe ', 01, 04, 0, MDFe.tot.qMDFe, DSC_QNF);
  Gerador.wCampo(tcDe2, '#073', 'vCarga', 01, 15, 1, MDFe.tot.vCarga, DSC_VDOC);
  Gerador.wCampo(tcStr, '#074', 'cUnid ', 02, 02, 1, UnidMedToStr(MDFe.tot.cUnid), DSC_CUNID);
  Gerador.wCampo(tcDe4, '#075', 'qCarga', 01, 15, 1, MDFe.tot.qCarga, DSC_QCARGA);
  Gerador.wGrupo('/tot');
end;

procedure TMDFeW.GerarLacres;
var
  i: Integer;
begin
  for i := 0 to MDFe.lacres.Count - 1 do
  begin
    Gerador.wGrupo('lacres', '#076');
    Gerador.wCampo(tcStr, '#077', 'nLacre', 01, 60, 1, MDFe.lacres[i].nLacre, DSC_NLACRE);
    Gerador.wGrupo('/lacres');
  end;
  if MDFe.lacres.Count > 990 then
    Gerador.wAlerta('#076', 'lacres', DSC_LACR, ERR_MSG_MAIOR_MAXIMO + '990');
end;

procedure TMDFeW.GerarautXML;
var
  i: Integer;
begin
  for i := 0 to MDFe.autXML.Count - 1 do
  begin
    Gerador.wGrupo('autXML', '#140');
    Gerador.wCampoCNPJCPF('#141', '#142', MDFe.autXML[i].CNPJCPF, CODIGO_BRASIL);
    Gerador.wGrupo('/autXML');
  end;
  if MDFe.autXML.Count > 10 then
    Gerador.wAlerta('#140', 'autXML', DSC_LACR, ERR_MSG_MAIOR_MAXIMO + '10');
end;

procedure TMDFeW.GerarInfAdic;
begin
  if (MDFe.infAdic.infAdFisco <> '') or (MDFe.infAdic.infCpl <> '')
   then begin
    Gerador.wGrupo('infAdic', '#078');
    Gerador.wCampo(tcStr, '#079', 'infAdFisco', 01, 2000, 0, MDFe.infAdic.infAdFisco, DSC_INFADFISCO);
    Gerador.wCampo(tcStr, '#080', 'infCpl    ', 01, 2000, 0, MDFe.infAdic.infCpl, DSC_INFCPL);
    Gerador.wGrupo('/infAdic');
   end;
end;

procedure TMDFeW.AjustarMunicipioUF(var xUF, xMun: String;
  var cMun: Integer; cPais: Integer; vxUF, vxMun: String; vcMun: Integer);
var
  PaisBrasil: boolean;
begin
  PaisBrasil := cPais = CODIGO_BRASIL;

  cMun := IIf(PaisBrasil, vcMun, CMUN_EXTERIOR);
  xMun := IIf(PaisBrasil, vxMun, XMUN_EXTERIOR);
  xUF  := IIf(PaisBrasil, vxUF, UF_EXTERIOR);
  
  xMun := ObterNomeMunicipio(xMun, xUF, cMun);
end;

function TMDFeW.ObterNomeMunicipio(const xMun, xUF: String;
  const cMun: Integer): String;
var
  i: Integer;
  PathArquivo, Codigo: String;
  List: TStringList;
begin
  result := '';
  if (FOpcoes.NormatizarMunicipios) and (cMun <> CMUN_EXTERIOR) then
  begin
    PathArquivo := FOpcoes.FPathArquivoMunicipios + 'MunIBGE-UF' + InttoStr(UFparaCodigo(xUF)) + '.txt';
    if FileExists(PathArquivo) then
    begin
      List := TStringList.Create;
      try
        List.LoadFromFile(PathArquivo);
        Codigo := IntToStr(cMun);
        i := 0;
        while (i < list.count) and (result = '') do
        begin
          if pos(Codigo, List[i]) > 0 then
            result := Trim(StringReplace(list[i], codigo, '', []));
          inc(i);
        end;
      finally
        List.free;
      end;
    end;
  end;
  if result = '' then
    result := xMun;
end;

end.


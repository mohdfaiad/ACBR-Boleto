{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{******************************************************************************
|* Historico
|*
|* 11/08/2010: Itamar Luiz Bermond
|*  - Inicio do desenvolvimento
|* 24/08/2010: R�gys Silveira
|*  - Acerto da exporta��o para PDF
|*  - Acerto para checar se o relat�rio foi realmente preparado
|     antes de continuar a imprir ou gerar o PDF
|*  - Acerto nas propriedades do arquivo PDF
|* 26/08/2010: R�gys Silveira / Itamar Bermond
|*  - Acerto na propriedade "PreparedReport"
******************************************************************************}
{$I ACBr.inc}

unit ACBrNFeDANFEFR;

interface

uses
  Forms, SysUtils, Classes, Graphics, ACBrNFeDANFEClass, ACBrNFeDANFEFRDM,
  pcnNFe, pcnConversao, frxClass;

type
  EACBrNFeDANFEFR = class(Exception);

  TACBrNFeDANFEFR = class( TACBrNFeDANFEClass )
   private
    FdmDanfe: TACBrNFeFRClass;
    FFastFile: String;
    FEspessuraBorda: Integer;
    FFastFileEvento: String;
    FShowDialog: Boolean;
    FExibirTotalTributosItem: Boolean;
    FExibeCampoFatura: Boolean;
    FTributosFonte: string;
    FTributosPercentual: TpcnPercentualTributos;
    FTributosPercentualPersonalizado: double;
    FMarcaDaguaMSG: string;
    FDetalhado: Boolean;
    FURLConsultaPublica:String;
    FDescricaoViaEstabelec: string;
    FImprimirUnQtVlComercial: boolean;
    FExpandirDadosAdicionaisAuto: boolean;
    FImprimirDadosArma: Boolean;
    fQuebraLinhaEmDetalhamentoEspecifico : Boolean;
    FIncorporarFontesPdf: Boolean;
    FIncorporarBackgroundPdf: Boolean;
    FFastFileInutilizacao: String;
    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;
		function GetPreparedReportInutilizacao: TfrxReport;
    function PrepareReport(NFE: TNFe = nil): Boolean;
    function PrepareReportEvento: Boolean;
    function PrepareReportInutilizacao: Boolean;    
    procedure setTributosPercentual(const Value: TpcnPercentualTributos);
    procedure setTributosPercentualPersonalizado(const Value: double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFE(NFE: TNFe = nil); override;
    procedure ImprimirDANFEResumido(NFE: TNFe = nil); override;
    procedure ImprimirDANFEPDF(NFE: TNFe = nil); override;
    procedure ImprimirEVENTO(NFE: TNFe = nil); override;
    procedure ImprimirEVENTOPDF(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAO(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(NFE: TNFe = nil); override;
  published
    property FastFile: String read FFastFile write FFastFile;
    property FastFileEvento: String read FFastFileEvento write FFastFileEvento;
    property FastFileInutilizacao: String read FFastFileInutilizacao write FFastFileInutilizacao;
    property dmDanfe: TACBrNFeFRClass read FdmDanfe write FdmDanfe;
    property EspessuraBorda: Integer read FEspessuraBorda write FEspessuraBorda;
    property PreparedReport: TfrxReport read GetPreparedReport;
    property PreparedReportEvento: TfrxReport read GetPreparedReportEvento;
		property PreparedReportInutilizacao: TfrxReport read GetPreparedReportInutilizacao;
    property ShowDialog: Boolean read FShowDialog write FShowDialog default false; // Isaque Pinheiro
    property ExibirTotalTributosItem: Boolean read FExibirTotalTributosItem write FExibirTotalTributosItem;
    property ExibeCampoFatura: Boolean read FExibeCampoFatura write FExibeCampoFatura;  //Incluido em 22/05/2013 - F�bio Gabriel
    property TributosFonte: string read FTributosFonte write FTributosFonte;
    property TributosPercentual: TpcnPercentualTributos read FTributosPercentual write setTributosPercentual;
    property TributosPercentualPersonalizado: double read FTributosPercentualPersonalizado write setTributosPercentualPersonalizado;
    property MarcaDaguaMSG: string read FMarcaDaguaMSG write FMarcaDaguaMSG;
    property ImprimirUnQtVlComercial: boolean read FImprimirUnQtVlComercial write FImprimirUnQtVlComercial;
    property Detalhado: Boolean read FDetalhado write FDetalhado;
    property URLConsultaPublica:String read FURLConsultaPublica write FURLConsultaPublica;
    property DescricaoViaEstabelec: string read FDescricaoViaEstabelec write FDescricaoViaEstabelec;
    property ExpandirDadosAdicionaisAuto: boolean read FExpandirDadosAdicionaisAuto write FExpandirDadosAdicionaisAuto;
    property ImprimirDadosArma: Boolean read FImprimirDadosArma write FImprimirDadosArma;
    property QuebraLinhaEmDetalhamentoEspecifico : Boolean  read fQuebraLinhaEmDetalhamentoEspecifico Write fQuebraLinhaEmDetalhamentoEspecifico;
    property IncorporarBackgroundPdf: Boolean read FIncorporarBackgroundPdf write FIncorporarBackgroundPdf;
    property IncorporarFontesPdf: Boolean read FIncorporarFontesPdf write FIncorporarFontesPdf;
  end;

implementation

uses ACBrNFe, ACBrUtil, StrUtils, Dialogs, pcnConversaoNFe;

constructor TACBrNFeDANFEFR.Create(AOwner: TComponent);
begin
  inherited create( AOwner );
  FdmDanfe := TACBrNFeFRClass.Create(Self);
  FFastFile := '' ;
  FEspessuraBorda := 1;
  FExibirTotalTributosItem := False;
  FExibeCampoFatura := True;
  FTributosFonte := '';
  FTributosPercentual := ptValorProdutos;
  FTributosPercentualPersonalizado := 0;
  FMarcaDaguaMSG:='';
  FImprimirUnQtVlComercial:=false;
  ExpandirDadosAdicionaisAuto:=false;
  { NFC-e }
  FvTroco := 0;
  FDetalhado := False;
  FDescricaoViaEstabelec := 'Via do Consumidor';// utilizado para NFC-e
  FURLConsultaPublica:= ''; //NFCe
  FImprimirDadosArma := True;
  fQuebraLinhaEmDetalhamentoEspecifico  := True;
  FIncorporarFontesPdf := True;
  FIncorporarBackgroundPdf := True;
end;

destructor TACBrNFeDANFEFR.Destroy;
begin
  FdmDanfe.Free;
  inherited Destroy;
end;

function TACBrNFeDANFEFR.GetPreparedReport: TfrxReport;
begin
  if Trim(FFastFile) = '' then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := FdmDanfe.frxReport
    else
      Result := nil;
  end;
end;

function TACBrNFeDANFEFR.GetPreparedReportEvento: TfrxReport;
begin
  if Trim(FFastFileEvento) = '' then
    Result := nil
  else
  begin
    if PrepareReportEvento then
      Result := FdmDanfe.frxReport
    else
      Result := nil;
  end;
end;

function TACBrNFeDANFEFR.GetPreparedReportInutilizacao: TfrxReport;
begin
  if Trim(FFastFileInutilizacao) = '' then
    Result := nil
  else
  begin
    if PrepareReportInutilizacao then
      Result := FdmDanfe.frxReport
    else
      Result := nil;
  end;
end;

function TACBrNFeDANFEFR.PrepareReport(NFE: TNFe): Boolean;
var
  I: Integer;
  wProjectStream: TStringStream;
  Page: TfrxReportPage;
begin
  Result := False;

  if ViaConsumidor then
    FDescricaoViaEstabelec := 'Via Consumidor'
  else
    FDescricaoViaEstabelec := 'Via Estabelecimento';

  FdmDanfe.ExibirTotalTributosItem := FExibirTotalTributosItem;
  FdmDanfe.ExibeCampoFatura :=  FExibeCampoFatura;
  FdmDanfe.TributosFonte :=  FTributosFonte;
  FdmDanfe.TributosPercentual :=  FTributosPercentual;
  FdmDanfe.TributosPercentualPersonalizado :=  FTributosPercentualPersonalizado;
  FdmDanfe.MarcaDaguaMSG :=  FMarcaDaguaMSG;
  FdmDanfe.ImprimirUnQtVlComercial := FImprimirUnQtVlComercial;
  FdmDanfe.ExpandirDadosAdicionaisAuto := FExpandirDadosAdicionaisAuto;
  FdmDanfe.vTroco := FvTroco;
  FdmDanfe.Detalhado := FDetalhado;
  FdmDanfe.DescricaoViaEstabelec := FDescricaoViaEstabelec;
  FdmDanfe.URLConsultaPublica    := FURLConsultaPublica;
  FdmDanfe.ImprimirDadosArma := FImprimirDadosArma;
  FdmDanfe.QuebraLinhaEmDetalhamentoEspecifico := fQuebraLinhaEmDetalhamentoEspecifico;
  FdmDanfe.IncorporarBackgroundPdf := FIncorporarFontesPdf;
  FdmDanfe.IncorporarFontesPdf := FIncorporarBackgroundPdf;

  FdmDanfe.SetDataSetsToFrxReport;
  if Trim(FastFile) <> '' then
  begin
    if not (uppercase(copy(FastFile,length(FastFile)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFile);
      FdmDanfe.frxReport.FileName := '';
      FdmDanfe.frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFile) then
        FdmDanfe.frxReport.LoadFromFile(FastFile)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o do DANFE "%s" inv�lido.', [FastFile]);
    end;
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o do DANFE n�o assinalado.');

  FdmDanfe.frxReport.PrintOptions.Copies := FNumCopias;
  FdmDanfe.frxReport.PrintOptions.ShowDialog := FShowDialog;
  FdmDanfe.frxReport.ShowProgress := FMostrarStatus;

//  if Assigned(ACBrNFe) then
//   if(TACBrNFe(ACBrNFe).Configuracoes.Geral.ModeloDF = moNFCe)then
//     FdmDanfe.frxReport.PrintOptions.PrintMode := pmSplit; 

  // Define a impressora
  if Length(Impressora) > 0 then
    FdmDanfe.frxReport.PrintOptions.Printer := FImpressora;

  // preparar relatorio
  if Assigned(NFE) then
  begin
    FdmDanfe.NFe := NFE;
    FdmDanfe.CarregaDadosNFe;

    Result := FdmDanfe.frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(ACBrNFe) then
    begin
      for i := 0 to TACBrNFe(ACBrNFe).NotasFiscais.Count - 1 do
      begin
        FdmDanfe.NFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[i].NFe;
        FdmDanfe.CarregaDadosNFe;

        if (i > 0) then
          Result := FdmDanfe.frxReport.PrepareReport(False)
        else
          Result := FdmDanfe.frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');
  end;

  for i := 0 to FdmDanfe.frxReport.PreviewPages.Count - 1 do
  begin
    Page := FdmDanfe.frxReport.PreviewPages.Page[i];
    if MargemSuperior > 0 then
      Page.TopMargin    := MargemSuperior * 10;
    if MargemInferior > 0 then
      Page.BottomMargin := MargemInferior * 10;
    if MargemEsquerda > 0 then
      Page.LeftMargin   := MargemEsquerda * 10;
    if MargemDireita > 0 then
      Page.RightMargin  := MargemDireita * 10;
    FdmDanfe.frxReport.PreviewPages.ModifyPage(i, Page);
  end;
end;

function TACBrNFeDANFEFR.PrepareReportEvento: Boolean;
var
 wProjectStream: TStringStream;
begin
  FdmDanfe.IncorporarBackgroundPdf := FIncorporarFontesPdf;
  FdmDanfe.IncorporarFontesPdf := FIncorporarBackgroundPdf;

  FdmDanfe.SetDataSetsToFrxReport;
  if Trim(FastFileEvento) <> '' then
  begin
    if not (uppercase(copy(FastFileEvento,length(FastFileEvento)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFileEvento);
      FdmDanfe.frxReport.FileName := '';
      FdmDanfe.frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFileEvento) then
        FdmDanfe.frxReport.LoadFromFile(FastFileEvento)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o do EVENTO "%s" inv�lido.', [FastFileEvento]);
    end
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o do EVENTO n�o assinalado.');

  FdmDanfe.frxReport.PrintOptions.Copies := NumCopias;
  FdmDanfe.frxReport.PrintOptions.ShowDialog := ShowDialog;

  // preparar relatorio
  if Assigned(ACBrNFe) then
  begin
    if assigned(TACBrNFe(ACBrNFe).EventoNFe) then
    begin
      FdmDanfe.Evento := TACBrNFe(ACBrNFe).EventoNFe;
      FdmDanfe.CarregaDadosEventos;
    end
    else
      raise EACBrNFeDANFEFR.Create('Evento n�o foi assinalado.');

    if TACBrNFe(ACBrNFe).NotasFiscais.Count > 0 then
    begin
      FdmDanfe.frxReport.Variables['PossuiNFe'] := QuotedStr('S');
      FdmDanfe.NFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFe;
      FdmDanfe.CarregaDadosNFe;
    end;

    Result := FdmDanfe.frxReport.PrepareReport;
  end
  else
    raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');
end;

function TACBrNFeDANFEFR.PrepareReportInutilizacao: Boolean;
var
 wProjectStream: TStringStream;
begin
  FdmDanfe.SetDataSetsToFrxReport;
  if Trim(FastFileInutilizacao) <> '' then
  begin
    if not (uppercase(copy(FastFileInutilizacao,length(FastFileInutilizacao)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFileInutilizacao);
      FdmDanfe.frxReport.FileName := '';
      FdmDanfe.frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFileInutilizacao) then
        FdmDanfe.frxReport.LoadFromFile(FastFileInutilizacao)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o de INUTILIZA��O "%s" inv�lido.', [FastFileInutilizacao]);
    end
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o de INUTILIZA��O n�o assinalado.');

  FdmDanfe.frxReport.PrintOptions.Copies := NumCopias;

  // preparar relatorio
  if Assigned(ACBrNFe) then
  begin
    if assigned(TACBrNFe(ACBrNFe).InutNFe) then
    begin
      FdmDanfe.Inutilizacao := TACBrNFe(ACBrNFe).InutNFe.RetInutNFe;
      FdmDanfe.CarregaDadosInutilizacao;
    end
    else
      raise EACBrNFeDANFEFR.Create('INUTILIZA��O n�o foi assinalada.');

    Result := FdmDanfe.frxReport.PrepareReport;
  end
  else
    raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');

end;

procedure TACBrNFeDANFEFR.setTributosPercentual(
  const Value: TpcnPercentualTributos);
begin
  FTributosPercentual := Value;
  if Value <> ptPersonalizado then
    FTributosPercentualPersonalizado := 0;
end;

procedure TACBrNFeDANFEFR.setTributosPercentualPersonalizado(
  const Value: double);
begin
  if FTributosPercentual=ptPersonalizado then
    FTributosPercentualPersonalizado := Value
  else
    FTributosPercentualPersonalizado := 0;
end;

procedure TACBrNFeDANFEFR.ImprimirDANFE(NFE: TNFe);
begin
  FDetalhado := True;

  if PrepareReport(NFE) then
  begin
    if MostrarPreview then
      FdmDanfe.frxReport.ShowPreparedReport
    else
      FdmDanfe.frxReport.Print;
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirDANFEResumido(NFE: TNFe);
begin
  FDetalhado := False;

  if PrepareReport(NFE) then
  begin
    if MostrarPreview then
      FdmDanfe.frxReport.ShowPreparedReport
    else
      FdmDanfe.frxReport.Print;
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirDANFEPDF(NFE: TNFe);
const
  TITULO_PDF = 'Nota Fiscal Eletr�nica';
var
  I: Integer;
	fsShowDialog : Boolean;
begin
  if PrepareReport(NFE) then
  begin
		with FdmDanfe do
		begin
			fsShowDialog := frxPDFExport.ShowDialog;
			frxPDFExport.Author        := Sistema;
			frxPDFExport.Creator       := Sistema;
			frxPDFExport.Producer      := Sistema;
			frxPDFExport.Title         := TITULO_PDF;
			frxPDFExport.Subject       := TITULO_PDF;
			frxPDFExport.Keywords      := TITULO_PDF;
			frxPDFExport.ShowDialog    := False;
			frxPDFExport.EmbeddedFonts := False;
			frxPDFExport.Background    := False;

			frxPDFExport.FileName := PathWithDelim(Self.PathPDF) +	OnlyNumber(NFe.infNFe.ID) + '-nfe.pdf';
	
			if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
				ForceDirectories(ExtractFileDir(frxPDFExport.FileName));
	
			frxReport.Export(frxPDFExport);
			frxPDFExport.ShowDialog := fsShowDialog;
    end;		
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirEVENTO(NFE: TNFe);
begin
  if PrepareReportEvento then
  begin
    if MostrarPreview then
      FdmDanfe.frxReport.ShowPreparedReport
    else
      FdmDanfe.frxReport.Print;
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirEVENTOPDF(NFE: TNFe);
const
  TITULO_PDF = 'Eventos Nota Fiscal Eletr�nica';
var
  NomeArq: String;
begin
  if PrepareReportEvento then
  begin
    FdmDanfe.frxPDFExport.Author     := Sistema;
    FdmDanfe.frxPDFExport.Creator    := Sistema;
    FdmDanfe.frxPDFExport.Producer   := Sistema;
    FdmDanfe.frxPDFExport.Title      := TITULO_PDF;
    FdmDanfe.frxPDFExport.Subject    := TITULO_PDF;
    FdmDanfe.frxPDFExport.Keywords   := TITULO_PDF;
    FdmDanfe.frxPDFExport.ShowDialog := False;

    NomeArq := StringReplace(TACBrNFe(ACBrNFe).EventoNFe.Evento.Items[0].InfEvento.id, 'ID', '', [rfIgnoreCase]);

    FdmDanfe.frxPDFExport.FileName := PathWithDelim(Self.PathPDF) + NomeArq + '-procEventoNFe.pdf';

    if not DirectoryExists(ExtractFileDir(FdmDanfe.frxPDFExport.FileName)) then
      ForceDirectories(ExtractFileDir(FdmDanfe.frxPDFExport.FileName));

    FdmDanfe.frxReport.Export(FdmDanfe.frxPDFExport);
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirINUTILIZACAO(NFE: TNFe);
begin
  if PrepareReportInutilizacao then
  begin
    if MostrarPreview then
      FdmDanfe.frxReport.ShowPreparedReport
    else
      FdmDanfe.frxReport.Print;
  end;
end;

procedure TACBrNFeDANFEFR.ImprimirINUTILIZACAOPDF(NFE: TNFe);
const
  TITULO_PDF = 'Inutiliza��o de Numera��o';
var
  NomeArq: String;
begin
  if PrepareReportInutilizacao then
  begin
    FdmDanfe.frxPDFExport.Author     := Sistema;
    FdmDanfe.frxPDFExport.Creator    := Sistema;
    FdmDanfe.frxPDFExport.Producer   := Sistema;
    FdmDanfe.frxPDFExport.Title      := TITULO_PDF;
    FdmDanfe.frxPDFExport.Subject    := TITULO_PDF;
    FdmDanfe.frxPDFExport.Keywords   := TITULO_PDF;
    FdmDanfe.frxPDFExport.ShowDialog := False;

    NomeArq := OnlyNumber(TACBrNFe(ACBrNFe).InutNFe.RetInutNFe.Id);

    FdmDanfe.frxPDFExport.FileName := PathWithDelim(Self.PathPDF) + NomeArq + '-ped-inu.pdf';

    if not DirectoryExists(ExtractFileDir(FdmDanfe.frxPDFExport.FileName)) then
      ForceDirectories(ExtractFileDir(FdmDanfe.frxPDFExport.FileName));

    FdmDanfe.frxReport.Export(FdmDanfe.frxPDFExport);
  end;
end;

end.

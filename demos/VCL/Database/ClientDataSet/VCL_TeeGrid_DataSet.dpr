program VCL_TeeGrid_DataSet;

uses
  Vcl.Forms,
  Unit_Dataset in 'Unit_Dataset.pas' {FormGridDataset};

{$R *.res}

begin
  {$IFOPT D+}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormGridDataset, FormGridDataset);
  Application.Run;
end.

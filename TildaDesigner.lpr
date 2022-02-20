program TildaDesigner;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FormTildaDesignMain, TildaDesignTypes, tildadesigndoc, 
FrameTildaDesignEdit, FrameTildaDesignModule, TildaDesignClasses,
FrameTildaDesignUIntrf, TildaDesignUtils, FormTildaDesignNewApp, 
FrameTildaDesignSubItems, FormTildaDesignAddSubItem, FrameTildaDesignView, 
FormTildaDesignScreen, FormTildaDesignEventRef, FormTildaDesignSelState, 
FormTildaDesignSelOptions, FrameTildaDesignElem, FormTildaDesignSelClr, 
FrameTildaDesignPage, FrameTildaDesignPanel
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
	Application.Scaled:= True;
  Application.Initialize;
	Application.CreateForm(TTildaDesignMainForm, TildaDesignMainForm);
	Application.CreateForm(TTildaDesignNewAppForm, TildaDesignNewAppForm);
	Application.CreateForm(TTildaDesignAddSubItemForm, TildaDesignAddSubItemForm
		);
	Application.CreateForm(TTildaDesignScreenForm, TildaDesignScreenForm);
	Application.CreateForm(TTildaDesignEventRefForm, TildaDesignEventRefForm);
	Application.CreateForm(TTildaDesignSelStateForm, TildaDesignSelStateForm);
	Application.CreateForm(TTildaDesignSelOptionsForm, TildaDesignSelOptionsForm
		);
	Application.CreateForm(TTildaDesignSelClrForm, TildaDesignSelClrForm);
  Application.Run;
end.


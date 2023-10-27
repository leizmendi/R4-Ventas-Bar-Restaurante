Attribute VB_Name = "basComprobarVinculos"
Option Compare Database
Option Explicit
    Global gm_Balanza As Integer, gm_H4 As Integer, _
           gm_Comandas As Integer, _
           gm_Reservas As Integer, _
           gm_CashLogy As Integer, _
           gm_CashGuard As Integer, _
           gm_Presencia As Integer, _
           gm_Almacen As Integer, _
           gm_HuellaD As Integer
    Global gint_ModulosCargadosSN As Integer

Public Sub CargaModulos()
    If gint_ModulosCargadosSN Then Exit Sub
    Dim strSQL As String
    gm_Balanza = Nz(DameValorParam("Modulos_Balanza"), False)
    gm_H4 = Nz(DameValorParam("Modulos_H4"), False)
    gm_Comandas = Nz(DameValorParam("Modulos_Comandas"), False)
    gm_Reservas = Nz(DameValorParam("Modulos_Reservas"), False)
    gm_CashLogy = Nz(DameValorParam("Modulos_CashLogy"), False)
    strSQL = "UPDATE sysSeleccionesVarias SET Visible = " & IIf(gm_CashLogy, "True", "False")
    strSQL = strSQL & " WHERE CodSeleccion = 'CA' AND (ValorOpcion = 6 OR ValorOpcion = 7 OR ValorOpcion = 8 OR ValorOpcion = 9)"
    On Error Resume Next
    CurrentDb.Execute strSQL, dbFailOnError
    gm_CashGuard = Nz(DameValorParam("Modulos_CashGuard"), False)
    gm_Presencia = Nz(DameValorParam("Modulos_Presencia"), False)
    gm_Almacen = Nz(DameValorParam("Modulos_Almacen"), False)
    gm_HuellaD = Nz(DameValorParam("Modulos_HuellaDactilar"), False)
    gint_ModulosCargadosSN = True
End Sub

Public Function ComprobarVinculos()
    Dim strCurDir As String, intR As Integer, strSQL As String, strCarDatos As String, strCarVentas As String
    strCurDir = miDirectorioDe(CurrentDb.Name)
    If strCurDir = DLookup("DirectorioDeConexion", "1myConexionTablas", "NombreTabla = '-X-X-'") Then
    Else
        DoCmd.OpenForm "frm1"
        strCarDatos = Nz(DameValorParamRemoto(strCurDir & "R4PST.mdb", "PuestoCarpetaVentas", "pstParam", True), strCurDir)
        strCarDatos = AbrirDialogo(, , , , "Seleccionar Carpeta de Ventas", "Carpeta Ventas", strCarDatos, , , , , True)
        If strCarDatos = "" Then
            MBox "Se cerrar� la aplicaci�n"
            DoCmd.Quit
        End If
        PonValorParamRemoto strCurDir & "R4PST.mdb", "PuestoCarpetaVentas", strCarDatos
        If right(strCarDatos, 1) <> "\" Then strCarDatos = strCarDatos & "\"
        DoCmd.Close acForm, "frm1"
        strSQL = "UPDATE 1myConexionTablas SET [1myConexionTablas].DirectorioActual = False, [1myConexionTablas].DirectorioDeConexion = " & ConComillas(strCarDatos)
        strSQL = strSQL & " WHERE FicheroDeConexion Like 'R4_Art.mdb'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'R4_Brm.mdb'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'R4_Pre.mdb'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'R4_Vta.mdb'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'R4_bal.mdb'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'H4_Link.mdb'"
        CurrentDb.Execute strSQL, dbFailOnError
        strCarVentas = strCarDatos
        DoCmd.OpenForm "frm1"
        strCarDatos = Nz(DameValorParamRemoto(strCurDir & "R4PST.mdb", "PuestoCarpetaFacturas", "pstParam", True), strCarDatos)
        strCarDatos = AbrirDialogo(, , , , "Seleccionar Carpeta de Facturas", "Carpeta Facturas", strCarDatos, , , , , True)
        If strCarDatos = "" Then
            MBox "Se cerrar� la aplicaci�n"
            DoCmd.Quit
        End If
        PonValorParamRemoto strCurDir & "R4PST.mdb", "PuestoCarpetaFacturas", strCarDatos
        If right(strCarDatos, 1) <> "\" Then strCarDatos = strCarDatos & "\"
        DoCmd.Close acForm, "frm1"
        strSQL = "UPDATE 1myConexionTablas SET [1myConexionTablas].DirectorioActual = False, [1myConexionTablas].DirectorioDeConexion = " & ConComillas(strCarDatos)
        strSQL = strSQL & " WHERE FicheroDeConexion Like 'R4Cli.mdb' AND NombreTabla Like 'tbFacturas*'"
        CurrentDb.Execute strSQL, dbFailOnError
    
        DoCmd.OpenForm "frm1"
        strCarDatos = Nz(DameValorParamRemoto(strCurDir & "R4PST.mdb", "PuestoCarpetaClientes", "pstParam", True), strCarDatos)
        strCarDatos = AbrirDialogo(, , , , "Seleccionar Carpeta de Clientes-Almac�n", "Carpeta Clientes-Almac�n", strCarDatos, , , , , True)
        If strCarDatos = "" Then
            MBox "Se cerrar� la aplicaci�n"
            DoCmd.Quit
        End If
        PonValorParamRemoto strCurDir & "R4PST.mdb", "PuestoCarpetaClientes", strCarDatos
        If right(strCarDatos, 1) <> "\" Then strCarDatos = strCarDatos & "\"
        DoCmd.Close acForm, "frm1"
        strSQL = "UPDATE 1myConexionTablas SET [1myConexionTablas].DirectorioActual = False, [1myConexionTablas].DirectorioDeConexion = " & ConComillas(strCarDatos)
        strSQL = strSQL & " WHERE FicheroDeConexion Like 'R4Cli.mdb' AND NombreTabla Not Like 'tbFacturas*'"
        strSQL = strSQL & " OR FicheroDeConexion Like 'R4_Alm.mdb'"
        CurrentDb.Execute strSQL, dbFailOnError
    
'        DoCmd.OpenForm "frm1"
'        strCarDatos = AbrirDialogo(, , , , "Seleccionar Carpeta de Reservas", "Carpeta Reservas", strCarDatos, , , , , True)
'        If strCarDatos = "" Then
'            mbox "Se cerrar� la aplicaci�n"
'            DoCmd.Quit
'        End If
'        If right(strCarDatos, 1) <> "\" Then strCarDatos = strCarDatos & "\"
'        DoCmd.Close acForm, "frm1"
        strSQL = "UPDATE 1myConexionTablas SET [1myConexionTablas].DirectorioActual = False, [1myConexionTablas].DirectorioDeConexion = " & ConComillas(strCarDatos)
        strSQL = strSQL & " WHERE FicheroDeConexion Like 'R4_Rsr.mdb'"
        CurrentDb.Execute strSQL, dbFailOnError
    
        ReconectarTablasYaVinculadas
        ReconectarTablasYaVinculadas , , strCarVentas & "R4_His.mdb"
        ReconectarTablasYaVinculadas , , strCarVentas & "R4_Vta.mdb"
        ReconectarTablasYaVinculadas , , strCarDatos & "R4Cli.mdb", strCarVentas
        'ReconectarTablasYaVinculadas , , strCurDir & "R4_Vta.mdb"
        'intR = mbox("�Volver a vincular la pr�xima vez que se inice el programa?", vbDefaultButton2 + vbYesNo + vbQuestion)
        intR = vbNo
        If intR = vbNo Then
            strSQL = "UPDATE 1myConexionTablas SET [1myConexionTablas].DirectorioDeConexion = '" & strCurDir & "'"
            strSQL = strSQL & " WHERE ((([1myConexionTablas].NombreTabla)='-X-X-'));"
            CurrentDb.Execute strSQL, dbFailOnError
        End If
        DoCmd.OpenForm "frmBotonesTPV", , , , , acHidden
        DoCmd.Close acForm, "frmBotonesTPV"
        Call SetParamReportAll
        PonSeleccionesVarias "TM"
    End If
    PonValorParam "AplicacionCurrentDir", strCurDir, 10
End Function
Private Function miDirectorioDe(strFullPath As String) As String
    Dim i As Integer
    On Error GoTo Error_miDirectorioDe
    For i = Len(strFullPath) To 1 Step -1
        If Mid(strFullPath, i, 1) = "\" Then
            miDirectorioDe = Left(strFullPath, i)
            Exit For
        End If
    Next i
Salir_miDirectorioDe:
    Exit Function
Error_miDirectorioDe:
    Select Case Err
        Case Else
            MBox "Error n�: " & Err & " en miDirectorioDe" & vbCrLf & Err.Description
    End Select
    Resume Salir_miDirectorioDe
End Function


Public Function ComprobarOpciones()
    On Error GoTo Error_ComprobarOpciones
    Dim rs As Recordset, v As Variant, vOld As Variant, intCambiar As Integer
    Set rs = CurrentDb.OpenRecordset("SELECT * FROM SysOpciones WHERE Activar = True")
    While Not rs.EOF
        vOld = Application.GetOption(rs("ArgumentoOpcion"))
        intCambiar = False
        Select Case rs("TipoOpcion")
            Case 1
                If vOld <> rs("OP_SN") Then
                    v = rs("OP_SN")
                    intCambiar = True
                End If
            Case 2
                If vOld <> rs("OP_TXT") Then
                    v = rs("OP_TXT")
                    intCambiar = True
                End If
            Case 3
                If vOld <> rs("OP_NUM") Then
                    v = rs("OP_NUM")
                    intCambiar = True
                End If
        End Select
        rs.Edit
        If intCambiar = False Then
            rs("Cambiado") = False
        Else
            SetOption rs("ArgumentoOpcion"), v
            rs("Cambiado") = True
            Select Case rs("TipoOpcion")
                Case 1
                    rs("OP_SN_OLD") = vOld
                Case 2
                    rs("OP_TXT_OLD") = vOld
                Case 3
                    rs("OP_NUM_OLD") = vOld
            End Select
        End If
        rs.Update
        rs.MoveNext
    Wend
Salir_ComprobarOpciones:
    Exit Function
Error_ComprobarOpciones:
    Select Case Err
        Case Else
            MBox "Error n� " & Err & " en ComprobarOpciones" & vbCrLf & Err.Description
            Resume Salir_ComprobarOpciones
    End Select
    
End Function
Public Function ReponerOpciones()
    On Error GoTo Error_ReponerOpciones
    Dim rs As Recordset, v As Variant, intCambiar As Integer
    
    Set rs = CurrentDb.OpenRecordset("SELECT * FROM SysOpciones WHERE Activar = True AND Cambiado = True")
    While Not rs.EOF
        Select Case rs("TipoOpcion")
            Case 1
                v = rs("OP_SN_OLD")
            Case 2
                v = rs("OP_TXT_OLD")
            Case 3
                v = rs("OP_NUM_OLD")
        End Select
        SetOption rs("ArgumentoOpcion"), v
        rs.MoveNext
    Wend
Salir_ReponerOpciones:
    Exit Function
Error_ReponerOpciones:
    Select Case Err
        Case Else
            MBox "Error n� " & Err & " en ReponerOpciones" & vbCrLf & Err.Description
            Resume Salir_ReponerOpciones
    End Select
    
End Function

Public Function Titulo_e_Icono()
    Dim intX As Integer
    Dim strTitulo As String, strIco As String
    strTitulo = Nz(DameValorParam("AplicacionTitulo"), "C4")
    intX = AddPropAp("AppTitle", dbText, strTitulo)
    strIco = DimeDondeEsta(Nz(DameValorParam("AplicacionIcono"), "Images\C4.ico"))
    intX = AddPropAp("AppIcon", dbText, strIco)
    RefreshTitleBar
End Function

Public Function AddPropAp(strName As String, varType As Variant, varValue As Variant) As Integer
    Dim dbs As Database, prp As Object
    Const conPropNotFoundError = 3270

    Set dbs = CurrentDb
    On Error GoTo AddProp_Err
    dbs.Properties(strName) = varValue

AddPropAp = True

AddProp_Bye:
    Exit Function

AddProp_Err:
    If Err = conPropNotFoundError Then
        Set prp = dbs.CreateProperty(strName, varType, varValue)
        dbs.Properties.Append prp
        Resume Next
    Else
        AddPropAp = False
        Resume AddProp_Bye
    End If
End Function

Public Function DimeDondeEsta(strFile As String) As String
' Si en strFile no existe una unidad (:) ni una direcci�n de red (empieza por \\) devuelve
' el path completo de la situaci�n relativa.... ejem
    Dim strX As String, i As Integer
    On Error GoTo Error_DimeDondeEsta
    If InStr(strFile, "\\") = 1 Then
        DimeDondeEsta = strFile
        Exit Function
    End If
    If InStr(strFile, ":") > 0 Then
        DimeDondeEsta = strFile
        Exit Function
    End If
    strX = DameValorParam("AplicacionCurrentDir")
    strX = strX & "\" & strFile
Quitar2Barras:
    i = InStr(strX, "\\")
    If i > 0 Then
        strX = Left(strX, i) & Mid(strX, i + 2)
        GoTo Quitar2Barras
    End If
    DimeDondeEsta = strX
Salir_DimeDondeEsta:
    Exit Function
Error_DimeDondeEsta:
    Select Case Err
        Case Else
            MBox "Error n�: " & Err & " en DimeDondeEsta" & vbCrLf & Err.Description
    End Select
    Resume Salir_DimeDondeEsta
End Function

Public Function DimePathRelativo(strFile As String) As String
' Si en strFile no existe una unidad (:) ni una direcci�n de red (empieza por \\) devuelve
' el path completo de la situaci�n relativa.... ejem
    Dim strCurDir As String, i As Integer
    On Error GoTo Error_DimePathRelativo
    strCurDir = DameValorParam("AplicacionCurrentDir")
    If InStr(strFile, strCurDir) = 1 Then
        strFile = Mid(strFile, Len(strCurDir) + 1)
    End If
    DimePathRelativo = strFile
Salir_DimePathRelativo:
    Exit Function
Error_DimePathRelativo:
    Select Case Err
        Case Else
            MBox "Error n�: " & Err & " en DimePathRelativo" & vbCrLf & Err.Description
    End Select
    Resume Salir_DimePathRelativo
End Function

Public Sub TipoAplicacion()
    Call CargaModulos
    If Nz(DameValorParam("AplicacionInicioColor"), 0) = 0 Then
        gintDemo = False
        'PonValorParam "EstablecimientoNombre", "Versi�n demostraci�n"
        'PonValorParam "TicketsCabecera", "Versi�n demostraci�n"
        'PonValorParam "FacturasCabecera", "Versi�n demostraci�n"
        'PonValorParam "AplicacionTitulo", "Versi�n demostraci�n"
    Else
        gintDemo = False
    End If
End Sub

Public Function BarraBasica()
    Dim barra As Object
    'Dim lngIdPuesto  As Long, intServidor As Integer
    On Error Resume Next
    For Each barra In Application.CommandBars
        barra.Visible = False
    Next
    'lngIdPuesto = Nz(DLookup("IdPuesto", "cfgPuestos", "NombrePuesto= " & ConComillas(Nz(DameValorParam("PuestoNombre"), ""))), 0)
    'intServidor = Nz(DLookup("ServidorSN", "cfgPuestos", "IdPuesto= " & lngIdPuesto), False)
    
    Application.CommandBars("Basica").Visible = Nz(DameValorParam("PuestoBarraBasicaVisibleSN"), False)
    Set barra = CommandBars.ActiveMenuBar
    If Nz(DameValorParam("PuestoBarraMenusVisibleSN"), False) = True Then
        Application.CommandBars("Basica").Left = 0
        barra.Enabled = True
    Else
        barra.Enabled = False
    End If
End Function

Public Function Autoexec()
    On Error GoTo Error_Autoexec
'    Call Checkref
    Autoexec2
Salir_Autoexec:
    Exit Function
Error_Autoexec:
    Select Case Err
        Case Else
            MBox "error n� " & Err & " en Autoexec" & vbCrLf & Err.Description
            Resume Salir_Autoexec
    End Select
End Function
Public Function Autoexec2()
    On Error GoTo Error_Autoexec2
    'DoCmd.ShowToolbar "Ribbon", acToolbarNo
    'DoCmd.ShowToolbar "Menu Bar", acToolbarNo
    Call TipoAplicacion
    Call ComprobarVinculos
    Call ComprobarOpciones
    Call ComprobarUpdates
    Call Titulo_e_Icono
    Call Pon_glngMiPuesto
    'Call GenerarMenus2
    Call SetBypassProperty
    Call fSetAccessWindow(3)
    'Call quitaMinMax
    'Call BarraBasica
    If Nz(DameValorParam("ListadosEnviarProgramadosICN"), 3) = 1 Then
        EnvioListadosProgramados Nz(DameValorParam("ListadosEnvioProgramadosConfirmarSN"), True)
    End If
    If Nz(DameValorParam("PuestoAlIniciarActualizarEmpleadosActivos"), False) Then Call PonCamarerosActivosAhora
    'If gintSoyServidor Then ImportarVentas
    If Nz(DameValorParam("PuestoAlIniciarImportarVentas"), False) Then
        'Importar_Ventas_Puestos
        If Month(Date) = 1 Then CopiarNuevosHistoricos , Year(Date) - 1
        CopiarNuevosHistoricos
    End If
    ComprobarCampos
    PonSeleccionesVarias "TM"
    DoCmd.OpenForm DameValorParam("AplicacionFormularioInicio")
    DoCmd.Maximize
Salir_Autoexec2:
    Exit Function
Error_Autoexec2:
    Select Case Err
        Case Else
            MBox "error n� " & Err & " en Autoexec2" & vbCrLf & Err.Description
            Resume Salir_Autoexec2
    End Select
End Function

Public Function CompactarYReparar(strMDB As String) As Integer
    On Error GoTo Error_CompactarYReparar
    Dim strLDB As String, strOLD As String, strDir As String, strBSN As String
    Dim intCopiarOLD As Integer
    strLDB = RecDerTop(strMDB, 3, 0) & "ldb"
    If Dir(strLDB) <> "" Then
        MBox "No se pudo compactar y reparar " & strMDB & " por estar actualmente en uso"
        CompactarYReparar = False
        Exit Function
    End If
    strDir = DirectorioDe(strMDB)
    strBSN = Mid(strMDB, Len(strDir) + 1)
    'strOLD = RecDerTop(strMDB, 3, 0) & "old"
    strOLD = strDir & "OLD\" & RecDerTop(strBSN, 3, 0) & "old"
    If Dir(strMDB & "_REP") <> "" Then Kill strMDB & "_REP"
    Application.CompactRepair strMDB, strMDB & "_REP"
    intCopiarOLD = 1
    FileCopy strMDB, strOLD
    intCopiarOLD = 0
    FileCopy strMDB & "_REP", strMDB
    Kill strMDB & "_REP"
    CompactarYReparar = True
Salir_CompactarYReparar:
    Exit Function
Error_CompactarYReparar:
    Select Case Err
        Case 76
            If intCopiarOLD = 1 Then
                MkDir strDir & "OLD"
                Resume
            End If
            MBox "Error n� " & Err & " en CompactarYReparar" & vbCrLf & Err.Description
            Resume Salir_CompactarYReparar
        Case Else
            MBox "Error n� " & Err & " en CompactarYReparar" & vbCrLf & Err.Description
            Resume Salir_CompactarYReparar
    End Select
            

End Function


Public Function VaciarBaseRemota(strMDB As String)
    Dim strSQL As String, rs As Recordset, i As Integer, j As Integer
    Dim qdf As QueryDef, str As String, db As Database
    On Error GoTo Error_VaciarBaseRemota
    Set db = OpenDatabase(strMDB)
    Set rs = db.OpenRecordset("SELECT * FROM _BorrarTablas_ ORDER BY Orden", dbOpenSnapshot)
    While Not rs.EOF
        SysCmd acSysCmdSetStatus, "Borrando " & rs("Tabla")
        db.Execute "DELETE * FROM " & rs("Tabla"), dbFailOnError
        rs.MoveNext
        i = i + 1
    Wend
    MBox "Se borraron " & i & " tablas"
    
SiguienteQdf:
Salir_VaciarBaseRemota:
    SysCmd acSysCmdClearStatus
    Exit Function
Error_VaciarBaseRemota:
    Select Case Err
        Case Else
            MBox "Error n� " & Err & " en VaciarBaseRemota" & vbCrLf & Err.Description
            Resume Salir_VaciarBaseRemota
    End Select
End Function

Public Function A�adir_Campo(ByVal strTabla As String, strNombreCampo As String, intTipo As Integer, Optional intSize As Integer = 0, Optional ByRef strMensaje As String, Optional ByVal strMDB As String = "Current") As Integer
'Genera nuevos campos en "& strtabla &"
    On Error GoTo Error_A�adir_Campo
    
    Dim db As Database, ws As Workspace
    Dim tdf As TableDef, fld As Field, ind As index
    On Error GoTo Error_A�adir_Campo
    If strMDB = "current" Then
        If DLookup("DirectorioActual", "1myConexionTablas", "NombreTabla = '" & strTabla & "'") = True Then
            strMDB = DirectorioDe(CurrentDb.Name)
        Else
            strMDB = DLookup("DirectorioDeConexion", "1myConexionTablas", "NombreTabla = '" & strTabla & "'")
        End If
        strMDB = strMDB & DLookup("FicheroDeConexion", "1myConexionTablas", "NombreTabla = '" & strTabla & "'")
    End If
    Set ws = DBEngine.Workspaces(0)
    Set db = ws.OpenDatabase(strMDB)
    If Nz(DLookup("NombreTablaRemoto", "1myConexionTablas", "NombreTabla = '" & strTabla & "'"), "") <> "" Then
        strTabla = DLookup("NombreTablaRemoto", "1myConexionTablas", "NombreTabla = '" & strTabla & "'")
    End If
    Set tdf = db.TableDefs(strTabla)
    If intSize = 0 Then
        Set fld = tdf.CreateField(strNombreCampo, intTipo)
    Else
        Set fld = tdf.CreateField(strNombreCampo, intTipo, intSize)
    End If
    tdf.Fields.Append fld
    Set tdf = Nothing
    strMensaje = "Se a�adi� el campo " & strNombreCampo & " en la tabla " & strTabla & " en " & strMDB
    A�adir_Campo = True
Salir_A�adir_Campo:
    Exit Function
Error_A�adir_Campo:
    Select Case Err
        Case 3057
            A�adir_Campo = False
            Resume Salir_A�adir_Campo
        Case Else
            MBox "Error n� " & Err & " en A�adir_Campo" & vbCrLf & Err.Description
            strMensaje = "NO se pudo a�adir el campo " & strNombreCampo & " en la tabla " & strTabla & " en " & strMDB
            A�adir_Campo = False
            Resume Salir_A�adir_Campo
    End Select
End Function

Public Function ComprobarCampos(Optional strMDB As String = "Current")
    Dim fld As Field, strMsg As String, strMsg2 As String, tdf As TableDef
    Dim strSQL As String, rs As Recordset, db As Database
    Dim strTabla As String
    On Error GoTo Error_ComprobarCampos
    Set rs = CurrentDb.OpenRecordset("SELECT * FROM sysComprobarCampos ORDER By ID", dbOpenSnapshot)
    If strMDB = "Current" Then
        Set db = CurrentDb
    Else
        Set db = OpenDatabase(strMDB)
    End If
    While Not rs.EOF
        If strMDB <> "Current" Then
            On Error Resume Next
            Set tdf = db.TableDefs(rs("NombreTabla"))
            If Err <> 0 Then GoTo SiguienteCampo
            On Error GoTo Error_ComprobarCampos
        End If
        
        strTabla = rs("NombreTabla")
VerCampo:
        On Error Resume Next
        Set fld = db.TableDefs(strTabla).Fields(rs("NombreCampo"))
        If Err <> 0 Then '
            On Error GoTo Error_ComprobarCampos
            strMsg2 = ""
            If A�adir_Campo(strTabla, rs("NombreCampo"), rs("TipoCampo"), rs("Tama�o"), strMsg2, strMDB) = True Then
                db.Close
                If strMDB = "Current" Then
                    Set db = CurrentDb
                Else
                    Set db = OpenDatabase(strMDB)
                End If
            End If
            strMsg = strMsg & strMsg2 & vbCrLf
        End If
        If strTabla = "tbTickCab" Then
            strTabla = "tbcli_TickCab"
            On Error Resume Next
            Set tdf = db.TableDefs(strTabla)
            If Err = 0 Then GoTo VerCampo
        ElseIf strTabla = "tbTickDet" Then
            strTabla = "tbcli_TickDet"
            On Error Resume Next
            Set tdf = db.TableDefs(strTabla)
            If Err = 0 Then GoTo VerCampo
        ElseIf strTabla = "tbTickCab_Cli" Then
            strTabla = "tbcli_TickCab_Cli"
            On Error Resume Next
            Set tdf = db.TableDefs(strTabla)
            If Err = 0 Then GoTo VerCampo
        ElseIf strTabla = "tbPresenciaBarm" Then
            strTabla = "auxPresenciaBarm"
            On Error Resume Next
            Set tdf = db.TableDefs(strTabla)
            If Err = 0 Then GoTo VerCampo
        End If
SiguienteCampo:
        On Error GoTo Error_ComprobarCampos
        rs.MoveNext
    Wend
    If strMsg <> "" Then MBox strMsg
Salir_ComprobarCampos:
    Exit Function
Error_ComprobarCampos:
    Select Case Err
        Case Else
            MBox "Error n� " & Err & " en ComprobarCampos" & vbCrLf & Err.Description
            Resume Salir_ComprobarCampos
    End Select


End Function

Public Function DimeMisReferencias() As String
    On Error GoTo Error_DimeMisReferencias
    Dim ref As Reference
    Dim strRefs As String, i As Integer, strLin As String, strFile As String, FSO As New FileSystemObject
    For Each ref In Application.References
        strRefs = strRefs & ref.FullPath & vbCrLf
    Next ref
    If Len(strRefs) > 2 Then strRefs = RecDerTop(strRefs, 2, 0)
    If True Then 'strCarpetaCopia <> "" Then
        'If right(strCarpetaCopia, 1) <> "\" Then strCarpetaCopia = strCarpetaCopia & "\"
        CurrentDb.Execute "DELETE * FROM cfgParam WHERE NP Like 'References_*'", dbFailOnError
        For i = 1 To LineasDeStr(strRefs)
            strLin = ExtraeLin(strRefs, i)
            'strFile = Mid(strLin, Len(DirectorioDe(strLin)) + 1)
            PonValorParam "References_" & Format(i, "00"), strLin, 12
            'If InStr(strLin, "~") = 0 Then
            '    fso.CopyFile ConComillas(strLin), strCarpetaCopia & strFile
            '    'FileCopy ConComillas(strLin), strCarpetaCopia & strFile
            'End If
        Next i
    End If
    DimeMisReferencias = strRefs
Salir_DimeMisReferencias:
    Exit Function
Error_DimeMisReferencias:
    Select Case Err
        Case Else
            MBox "Error n� " & Err & " en DimeMisReferencias" & vbCrLf & Err.Description
            Resume Next 'Salir_DimeMisReferencias
    End Select
End Function

Public Function ArreglaReferencias()
    On Error GoTo Error_ArreglaReferencias

    Dim rs As Recordset
    Dim ref As Reference
    Dim msg As String
    Dim strRef As String, strDirRef As String
    strDirRef = DirectorioDe(CurrentDb.Name) & "Referencias\"
Ini:
    For Each ref In Application.References
        ' Check IsBroken property.
        If ref.IsBroken = True Then
            strRef = strDirRef & Mid(ref.FullPath, Len(DirectorioDe(ref.FullPath)) + 1)
            If Dir(strRef) <> "" Then
                References.Remove ref
                References.AddFromFile strRef
                GoTo Ini
            Else
                msg = "Falta Referencia: " & strRef
            End If
        End If
    Next ref

    If Len(msg) > 0 Then
        MBox msg, vbExclamation
    Else
        MBox "OK", vbInformation
    End If
    
Salir_ArreglaReferencias:
    Exit Function
Error_ArreglaReferencias:
    ' error codes 3075 and 3085 need special handling
    Select Case Err
        Case 3075, 3085
            Err.Clear
            FixUpRefs
        Case Else
            MBox "Error n� " & Err & " en ArreglaReferencias" & vbCrLf & Err.Descripcion
            Resume Salir_ArreglaReferencias
    End Select
End Function



Public Function CheckRefs()
    On Error GoTo Handler

    Dim rs As Recordset
    Dim ref As Reference
    Dim msg As String

    For Each ref In Application.References
        ' Check IsBroken property.
        If ref.IsBroken = True Then
            msg = msg & "Name: " & ref.Name & vbTab
            msg = msg & "FullPath: " & ref.FullPath & vbTab
            msg = msg & "Version: " & ref.Major & "." & ref.Minor & vbCrLf
        End If
    Next ref

    If Len(msg) > 0 Then
        MBox msg, vbExclamation
    Else
        MBox "OK", vbInformation
    End If
    Exit Function

Handler:
    ' error codes 3075 and 3085 need special handling

    If Err.number = 3075 Or Err.number = 3085 Then
        Err.Clear
        'FixUpRefs
    Else
        rs.Close
        Set rs = Nothing
    End If
End Function

Private Sub FixUpRefs()
    Dim r As Reference, r1 As Reference
    Dim s As String

    ' search the first ref which isn't Access or VBA
    For Each r In Application.References
        If r.Name <> "Access" And r.Name <> "VBA" Then
            Set r1 = r
            Exit For
        End If
    Next
    s = r1.FullPath

    ' remove the reference and add it again from file
    References.Remove r1
    References.AddFromFile s

    ' hidden syscmd to compile the db
    Call SysCmd(504, 16483)
End Sub

Public Sub ComprobarUpdates()
    On Error GoTo HandleError
    Dim sCUpdate As String, sFUpdate As String, iObjType As AcObjectType, sObjName As String
    Dim sFImport As String, sCUpdated As String, sCSaved As String, i As Integer, f As Integer, sMsg As String
    Dim bScript As Boolean
    sCUpdate = DirectorioDe(CurrentDb.Name) & "Update"
    If Dir(sCUpdate, vbDirectory) = "" Then MkDir sCUpdate
    sCUpdate = sCUpdate & "\"
    
    Dim sFiles As String, vFiles As Variant
    sFUpdate = Dir(sCUpdate & "*.def")
    While sFUpdate <> ""
        sFiles = sFiles & "," & sFUpdate
        sFUpdate = Dir()
    Wend
    If sFiles = "" Then GoTo HandleExit
    
    sCUpdated = sCUpdate & "Updated"
    If Dir(sCUpdated, vbDirectory) = "" Then MkDir sCUpdated
    sCUpdated = sCUpdated & "\" & Format(Date, "yyyy_mm_dd")
    If Dir(sCUpdated, vbDirectory) = "" Then MkDir sCUpdated
    sCUpdated = sCUpdated & "\"
    
    sCSaved = sCUpdate & "Saved"
    If Dir(sCSaved, vbDirectory) = "" Then MkDir sCSaved
    sCSaved = sCSaved & "\" & Format(Date, "yyyy_mm_dd")
    If Dir(sCSaved, vbDirectory) = "" Then MkDir sCSaved
    sCSaved = sCSaved & "\"
    
    
    sFiles = Mid(sFiles, 2)
    vFiles = Split(sFiles, ",")
    For f = 0 To UBound(vFiles)
        bScript = False
        sFUpdate = vFiles(f)
        Select Case Left(sFUpdate, 2)
            Case "F_"
                iObjType = acForm
            Case "R_"
                iObjType = acReport
            Case "Q_"
                iObjType = acQuery
            Case "S_"
                iObjType = acMacro
            Case "M_"
                iObjType = acModule
            Case "K_"
                bScript = True
            Case Else
                MsgBox "No se reconoci� el tipo de archivo a importar: " & sFUpdate, vbExclamation
                GoTo HandleExit
        End Select
        i = InStrRev(sFUpdate, ".")
        sObjName = Mid(sFUpdate, 3, i - 3)
        MensajeBusyBox "Actualizando " & f + 1 & "/" & UBound(vFiles) + 1 & " : " & sFUpdate, "Actualizando H4", , True
        If Dir(sCSaved & sFUpdate) <> "" Then
            i = 0
            While Dir(sCSaved & sFUpdate & "_" & i) <> ""
                i = i + 1
            Wend
            FileCopy sCSaved & sFUpdate, sCSaved & sFUpdate & "_" & i
        End If
        If Not bScript Then
            SaveAsText iObjType, sObjName, sCSaved & sFUpdate
            LoadFromText iObjType, sObjName, sCUpdate & sFUpdate
        Else
            ExecuteAllScriptsFromJSON sCUpdate & sFUpdate
        End If
        sMsg = sMsg & ", " & sObjName
        FileCopy sCUpdate & sFUpdate, sCUpdated & sFUpdate
        Kill sCUpdate & sFUpdate
    Next f
    sMsg = Mid(sMsg, 3)
    MensajeBusyBox "Se actualizaron " & f & " objetos: " & sMsg, "Actualizado H4", True
    
HandleExit:
    Exit Sub
HandleError:
    MsgBox Err.Description
    Resume HandleExit
End Sub

Sub ExecuteAllScriptsFromJSON(jsonPath As String)
    On Error GoTo HandleError
    Dim FSO As Object
    Dim TextFile As Object
    Dim FileContent As String
    Dim JSON As Object
    Dim Key As Variant
    Dim Script As String
    
    'Crear un nuevo objeto FileSystemObject
    Set FSO = CreateObject("Scripting.FileSystemObject")
    'Abrir el archivo
    Set TextFile = FSO.OpenTextFile(jsonPath, 1)
    'Leer el contenido del archivo
    FileContent = TextFile.ReadAll
    'Cerrar el archivo
    TextFile.Close
    
    'Deserializar el JSON
    Set JSON = JsonConverter.ParseJson(FileContent)
    
    'Recorrer todas las claves del diccionario JSON
    For Each Key In JSON.Keys
        Script = JSON(Key)
        Script = Replace(Script, "''", """")
        'Ejecutar el script en la base de datos u otro sistema
        'Nota: Aseg�rate de que es seguro ejecutar el script antes de hacerlo.
        'Por motivos de seguridad, deber�as verificar y limpiar cualquier input que vaya a ser ejecutado.
        On Error Resume Next
        CurrentDb.Execute Script, dbFailOnError
        If Err.number <> 0 Then
            MsgBox "Error al ejecutar el script de la clave " & Key & ": " & Err.Description, vbExclamation
            Err.Clear
        End If
        On Error GoTo HandleError
    Next Key
    
    'Limpiar
    Set FSO = Nothing
    Set TextFile = Nothing
    Set JSON = Nothing
    
    
HandleExit:
    Exit Sub
HandleError:
    MsgBox Err.Description
    Resume HandleExit
End Sub



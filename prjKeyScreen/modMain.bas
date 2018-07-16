Attribute VB_Name = "modMain"
Option Explicit
Option Base 0

Private Type RECT
    Left   As Long
    Top    As Long
    Right  As Long
    Bottom As Long
End Type

Private Type PALETTEENTRY
    peRed   As Byte
    peGreen As Byte
    peBlue  As Byte
    peFlags As Byte
End Type

Private Type LOGPALETTE
    palVersion       As Integer
    palNumEntries    As Integer
    palPalEntry(255) As PALETTEENTRY
End Type

Private Type PicBmp
    Size As Long
    Type As Long
    hBmp As Long
    hpal As Long
    Reserved As Long
End Type

Private Type GUID
    Data1    As Long
    Data2    As Integer
    Data3    As Integer
    Data4(7) As Byte
End Type

Private Declare Function GetAsyncKeyState Lib "USER32" (ByVal vKey As Long) As Integer
Private Declare Function GetKeyState Lib "USER32" (ByVal nVirtKey As Long) As Integer
Private Declare Function GetForegroundWindow Lib "USER32" () As Long
Private Declare Function GetWindowRect Lib "USER32" (ByVal hWnd As Long, lpRect As RECT) As Long
Private Declare Function GetDC Lib "USER32" (ByVal hWnd As Long) As Long
Private Declare Function GetWindowDC Lib "USER32" (ByVal hWnd As Long) As Long
Private Declare Function CreateCompatibleDC Lib "GDI32" (ByVal hDC As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "GDI32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function SelectObject Lib "GDI32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function GetDeviceCaps Lib "GDI32" (ByVal hDC As Long, ByVal iCapabilitiy As Long) As Long
Private Declare Function GetSystemPaletteEntries Lib "GDI32" (ByVal hDC As Long, ByVal wStartIndex As Long, ByVal wNumEntries As Long, lpPaletteEntries As PALETTEENTRY) As Long
Private Declare Function CreatePalette Lib "GDI32" (lpLogPalette As LOGPALETTE) As Long
Private Declare Function SelectPalette Lib "GDI32" (ByVal hDC As Long, ByVal hPalette As Long, ByVal bForceBackground As Long) As Long
Private Declare Function RealizePalette Lib "GDI32" (ByVal hDC As Long) As Long
Private Declare Function BitBlt Lib "GDI32" (ByVal hDCDest As Long, ByVal XDest As Long, ByVal YDest As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hDCSrc As Long, ByVal XSrc As Long, ByVal YSrc As Long, ByVal dwRop As Long) As Long
Private Declare Function ReleaseDC Lib "USER32" (ByVal hWnd As Long, ByVal hDC As Long) As Long
Private Declare Function DeleteDC Lib "GDI32" (ByVal hDC As Long) As Long
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (PicDesc As PicBmp, RefIID As GUID, ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long


Private Const RASTERCAPS As Long = 38
Private Const RC_PALETTE As Long = &H100
Private Const SIZEPALETTE As Long = 104


Public Function CaptureWindow(ByVal hWndSrc As Long, ByVal bClient As Boolean, ByVal LeftSrc As Long, ByVal TopSrc As Long, ByVal WidthSrc As Long, ByVal HeightSrc As Long) As Picture

    Dim hDCMemory       As Long
    Dim hBmp            As Long
    Dim hBmpPrev        As Long
    Dim r               As Long
    Dim hDCSrc          As Long
    Dim hpal            As Long
    Dim hPalPrev        As Long
    Dim RasterCapsScrn  As Long
    Dim HasPaletteScrn  As Long
    Dim PaletteSizeScrn As Long
    Dim LogPal          As LOGPALETTE
    
    If bClient Then
        hDCSrc = GetDC(hWndSrc)
    Else
        hDCSrc = GetWindowDC(hWndSrc)
    End If
    hDCMemory = CreateCompatibleDC(hDCSrc)
    hBmp = CreateCompatibleBitmap(hDCSrc, WidthSrc, HeightSrc)
    hBmpPrev = SelectObject(hDCMemory, hBmp)
    RasterCapsScrn = GetDeviceCaps(hDCSrc, RASTERCAPS)
    HasPaletteScrn = RasterCapsScrn And RC_PALETTE
    PaletteSizeScrn = GetDeviceCaps(hDCSrc, SIZEPALETTE)
    If HasPaletteScrn And (PaletteSizeScrn = 256) Then
        LogPal.palVersion = &H300
        LogPal.palNumEntries = 256
        r = GetSystemPaletteEntries(hDCSrc, 0, 256, LogPal.palPalEntry(0))
        hpal = CreatePalette(LogPal)
        hPalPrev = SelectPalette(hDCMemory, hpal, 0)
        r = RealizePalette(hDCMemory)
    End If
    r = BitBlt(hDCMemory, 0, 0, WidthSrc, HeightSrc, hDCSrc, _
        LeftSrc, TopSrc, vbSrcCopy)
    hBmp = SelectObject(hDCMemory, hBmpPrev)
    If HasPaletteScrn And (PaletteSizeScrn = 256) Then
        hpal = SelectPalette(hDCMemory, hPalPrev, 0)
    End If
    r = DeleteDC(hDCMemory)
    r = ReleaseDC(hWndSrc, hDCSrc)
    Set CaptureWindow = CreateBitmapPicture(hBmp, hpal)
    
End Function

Public Function CreateBitmapPicture(ByVal hBmp As Long, ByVal hpal As Long) As Picture
    Dim r   As Long
    Dim pic As PicBmp
    Dim IPic          As IPicture
    Dim IID_IDispatch As GUID
    With IID_IDispatch
        .Data1 = &H20400
        .Data4(0) = &HC0
        .Data4(7) = &H46
    End With

    With pic
        .Size = Len(pic)
        .Type = vbPicTypeBitmap
        .hBmp = hBmp
        .hpal = hpal
    End With
    r = OleCreatePictureIndirect(pic, IID_IDispatch, 1, IPic)
    Set CreateBitmapPicture = IPic
End Function

Public Function CaptureActiveWindow() As Picture
    Dim hWndActive As Long
    Dim RectActive As RECT
    
    hWndActive = GetForegroundWindow()
    Call GetWindowRect(hWndActive, RectActive)
    
    With RectActive
        Set CaptureActiveWindow = CaptureWindow(hWndActive, False, 0, 0, _
                .Right - .Left, .Bottom - .Top)
    End With
End Function

Public Function getUP() As Boolean
    
    getUP = CBool(GetAsyncKeyState(vbKeyUp))
End Function

Public Function getDOWN() As Boolean
    
    getDOWN = CBool(GetAsyncKeyState(vbKeyDown))
End Function

Public Function getRIGHT() As Boolean
    
    getRIGHT = CBool(GetAsyncKeyState(vbKeyRight))
End Function

Public Function getLEFT() As Boolean
    
    getLEFT = CBool(GetAsyncKeyState(vbKeyLeft))
End Function

Public Function getFIRE() As Boolean
    
    getFIRE = CBool(GetAsyncKeyState(vbKeySpace))
End Function

Public Function fkey() As String

    Dim txt As String
    Dim key As Integer
    
    If (Not getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "N"
        key = 0
    ElseIf (getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "F"
        key = 1
    ElseIf (Not getFIRE()) And (getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "U"
        key = 2
    ElseIf (Not getFIRE()) And (Not getUP()) And (getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "R"
        key = 3
    ElseIf (Not getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (getLEFT()) And (Not getDOWN()) Then
        txt = "L"
        key = 4
    ElseIf (Not getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (getDOWN()) Then
        txt = "D"
        key = 5
    ElseIf (Not getFIRE()) And (getUP()) And (getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "UR"
        key = 6
    ElseIf (Not getFIRE()) And (getUP()) And (Not getRIGHT()) And (getLEFT()) And (Not getDOWN()) Then
        txt = "UL"
        key = 7
    ElseIf (Not getFIRE()) And (Not getUP()) And (getRIGHT()) And (Not getLEFT()) And (getDOWN()) Then
        txt = "DR"
        key = 8
    ElseIf (Not getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (getLEFT()) And (getDOWN()) Then
        txt = "DL"
        key = 9
    ElseIf (getFIRE()) And (getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "UF"
        key = 10
    ElseIf (getFIRE()) And (Not getUP()) And (getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "RF"
        key = 11
    ElseIf (getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (getLEFT()) And (Not getDOWN()) Then
        txt = "LF"
        key = 12
    ElseIf (getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (Not getLEFT()) And (getDOWN()) Then
        txt = "DF"
        key = 13
    ElseIf (getFIRE()) And (getUP()) And (getRIGHT()) And (Not getLEFT()) And (Not getDOWN()) Then
        txt = "URF"
        key = 14
    ElseIf (getFIRE()) And (getUP()) And (Not getRIGHT()) And (getLEFT()) And (Not getDOWN()) Then
        txt = "ULF"
        key = 15
    ElseIf (getFIRE()) And (Not getUP()) And (getRIGHT()) And (Not getLEFT()) And (getDOWN()) Then
        txt = "DRF"
        key = 16
    ElseIf (getFIRE()) And (Not getUP()) And (Not getRIGHT()) And (getLEFT()) And (getDOWN()) Then
        txt = "DLF"
        key = 17
    Else
        txt = "N"
        key = 0
    End If
    
    fkey = key & "." & txt
End Function


VERSION 5.00
Begin VB.Form frmMain 
   Appearance      =   0  'Flat
   BackColor       =   &H00404040&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "frmPrepareData"
   ClientHeight    =   3495
   ClientLeft      =   540
   ClientTop       =   885
   ClientWidth     =   6855
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3495
   ScaleWidth      =   6855
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   1320
      Tag             =   "0"
      Top             =   720
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00404040&
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   2655
      Left            =   120
      TabIndex        =   4
      Top             =   720
      Width           =   1575
      Begin VB.TextBox txtFolderName 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   120
         TabIndex        =   1
         Text            =   "Pics01"
         Top             =   720
         Width           =   1215
      End
      Begin VB.TextBox txtFrameRate 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   840
         Locked          =   -1  'True
         TabIndex        =   5
         TabStop         =   0   'False
         Text            =   "100"
         Top             =   1320
         Width           =   495
      End
      Begin VB.HScrollBar HScroll1 
         Height          =   255
         LargeChange     =   50
         Left            =   120
         Max             =   500
         Min             =   10
         SmallChange     =   10
         TabIndex        =   2
         Top             =   1680
         Value           =   100
         Width           =   1215
      End
      Begin VB.CheckBox chkShowPics 
         BackColor       =   &H00404040&
         Caption         =   "Show Pics"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   2160
         Width           =   1215
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Folder name:"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label Label2 
         BackStyle       =   0  'Transparent
         Caption         =   "miliSec:"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   1320
         Width           =   615
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1575
   End
   Begin VB.Image Picture1 
      BorderStyle     =   1  'Fixed Single
      Height          =   3255
      Left            =   1800
      Stretch         =   -1  'True
      Tag             =   "0"
      Top             =   120
      Width           =   4935
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    
    If Dir("Data", vbDirectory) = "" Then
        MkDir ("Data")
    End If
    
    If Timer1.Enabled = True Then
    
        Timer1.Enabled = False
        Command1.Caption = "Start"
        txtFolderName.Enabled = True
        HScroll1.Enabled = True
    Else
        
        Timer1.Enabled = True
        Command1.Caption = "Stop"
        Picture1.Tag = Str(0)
        Timer1.Interval = HScroll1.Value
        txtFolderName.Enabled = False
        HScroll1.Enabled = False
        If Dir("Data\" & txtFolderName.Text, vbDirectory) = "" Then
            MkDir ("Data\" & txtFolderName.Text)
        End If
    End If
End Sub

Private Sub Form_Load()
    
    If Dir("Data", vbDirectory) = "" Then
        MkDir ("Data")
    End If
End Sub

Private Sub HScroll1_Change()
    
    txtFrameRate.Text = HScroll1.Value
End Sub

Private Sub Timer1_Timer()
    
    Dim fname As String
    
    Set pic = CaptureActiveWindow()
    If chkShowPics.Value Then
        
        Set Picture1.Picture = pic
    End If
    fname = "Data\" & txtFolderName.Text & "\" & X(Trim(Picture1.Tag)) & "." & fkey()
    Picture1.Tag = Str(Int(Picture1.Tag) + 1)
    'SavePicture pic, fname & ".bmp"
    PicSave.SavePicture pic, fname & ".png", fmtPNG, 100
    Me.Caption = fname
End Sub

Private Sub txtFolderName_GotFocus()
    txtFolderName.SelStart = 0
    txtFolderName.SelLength = Len(txtFolderName.Text)
    'txtFolderName.SelText = txtFolderName.Text
End Sub

Private Function X(inp As String) As String

    If Int(inp) < 10 Then
        X = "0000" & Trim(Str(inp))
    ElseIf Int(inp) < 100 Then
        X = "000" & Trim(Str(inp))
    ElseIf Int(inp) < 1000 Then
        X = "00" & Trim(Str(inp))
    ElseIf Int(inp) < 10000 Then
        X = "0" & Trim(Str(inp))
    Else
        X = Trim(Str(inp))
    End If
End Function

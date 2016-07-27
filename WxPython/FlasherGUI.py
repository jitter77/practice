import os
import subprocess
import wx
from signal import signal, SIGPIPE, SIG_DFL


class ExamplePanel(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)
        menubar = wx.MenuBar()
        mainSizer = wx.BoxSizer(wx.VERTICAL)
        grid = wx.GridBagSizer(hgap=5, vgap=5)
        hSizer = wx.BoxSizer(wx.HORIZONTAL)
        signal(SIGPIPE, SIG_DFL)

        menubar = wx.MenuBar()
        file = wx.Menu()
        play = wx.Menu()
        view = wx.Menu()
        tools = wx.Menu()
        favorites = wx.Menu()
        help = wx.Menu()

        file.Append(101, '&quit', 'Quit application')

        menubar.Append(file, '&File')
        menubar.Append(play, '&Play')
        menubar.Append(view, '&View')
        menubar.Append(tools, '&Tools')
        menubar.Append(favorites, 'F&avorites')
        menubar.Append(help, '&Help')
        #self.menubar


        self.quote = wx.StaticText(self, label="Choose Module :")
        grid.Add(self.quote, pos=(0, 0))

        # A multiline TextCtrl - This is here to show how the events work in this program, don't pay too much attention to it
        self.logger = wx.TextCtrl(self, pos=(200, 20), size=(400, 400), style=wx.TE_MULTILINE | wx.TE_READONLY)

        # Buttons
        # Polytouchdemo TX28 ID Number 1
        self.button = wx.Button(self, 281, label="Polytouchdemo\n TX28", pos=(10, 50))
        self.Bind(wx.EVT_BUTTON,self.OnClick, self.button)
        self.button = wx.Button(self, )
        # Polytouchdemo TX6UL ID Number 1
        self.button = wx.Button(self, 611, label="Polytouchdemo\n TX6UL", pos=(10, 100))
        self.Bind(wx.EVT_BUTTON, self.OnClick, self.button)
        # Polytouchdemo TX6S ID Number 1
        self.button = wx.Button(self, 621, label="Polytouchdemo\n TX6S", pos=(10, 150))
        self.Bind(wx.EVT_BUTTON,self.OnClick, self.button)
        # Polytouchdemo TX6DL ID Number 1
        self.button = wx.Button(self, 631, label="Polytouchdemo\n TX6DL", pos=(10, 200))
        self.Bind(wx.EVT_BUTTON,self.OnClick, self.button)
        # Polytouchdmeo TX6Q ID Number 1
        self.button = wx.Button(self, 641, label="Polytouchdemo\n TX6Q", pos=(10, 250))
        self.Bind(wx.EVT_BUTTON,self.OnClick, self.button)

    def OnClick(self, event):
        self.logger.AppendText(" Clicked on %d\n" % event.GetId())
        test = os.geteuid()
        self.logger.AppendText(" ID: %d\n" % test)
        if event.GetId() == 281:
            self.logger.AppendText("TX28 geklickt!")
            subprocess.Popen('/home/dp/polytouch_tx28.sh')
        elif event.GetId() == 611:
            self.logger.AppendText("TX6 geklickt!")
            subprocess.Popen('/home/dp/.sh')
        elif event.GetId() == 621:
            self.logger.AppendText("TX6S geklickt")
            subprocess.Popen('/home/dp/.sh')
        elif event.GetId() == 631:
            self.logger.AppendText("TX6DL geklickt!")
            subprocess.Popen('/Home/dp/.sh')
        elif event.GetId() == 641:
            self.logger.AppendText("TX6Q geklickt!")
            subprocess.Popen('/home/dp/.sh')


app = wx.App(False)
frame = wx.Frame(None)
panel = ExamplePanel(frame)
frame.SetTitle('TX Flasher')
frame.Show()
app.MainLoop()
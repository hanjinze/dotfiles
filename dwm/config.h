/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
/* appearance */
static const char font[]            = "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#073642";
static const char normbgcolor[]     = "#002b36";
static const char normfgcolor[]     = "#fdf6e3";
static const char selbordercolor[]  = "#586e75";
static const char selbgcolor[]      = "#073642";
static const char selfgcolor[]      = "#fdf6e3";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 12;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */
static const unsigned int systrayspacing = 2;   /* systray spacing */                                                                 
static const Bool showsystray       = True;     /* False means no systray */  
/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
	{ "Firefox",  NULL,       NULL,       2,            False,       -1 },
        { "MPlayer",  NULL,       NULL,       0,            True,        -1 },
        { "feh",      NULL,       NULL,       0,            True,        -1 },
        { "Chrome",   NULL,       NULL,       2,            False,        0 },
        { "Pcmanfm",  NULL,       NULL,       4,            False,        1 },
        { "Thunar",   NULL,       NULL,       4,            False,        1 },
        { "Geeqie",   NULL,       NULL,       0,            True,        -1 },
        { "Viewnior", NULL,       NULL,       0,            True,        -1 },
        { "Uzbl-tabbed",    NULL,   NULL,     0,            True,         0 },
        { "Gifview",  NULL,       NULL,       0,            True,        -1 },
        { "Pidgin",         NULL,   NULL,     0,            True,        -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
        { "[G]",      grid }, 
        { "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[]   =   { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]    =   { "st", NULL };
static const char *browsercmd[] =   { "chrome", NULL };
static const char *screenshot[] =   { "/home/derek/bin/screenshot.sh", NULL };
static const char *windowshot[] =   { "/home/derek/bin/screenshot.sh", "-window", NULL };
static const char *volup[]      =   { "mixer", "vol", "+2", NULL };
static const char *voldown[]    =   { "mixer", "vol", "-2", NULL };
static const char *volmute[]    =   { "amixer", "-c", "0", "-q", "set", "Master", "toggle", NULL };
static const char *nexttrack[]  =   { "mpc", "next", NULL };
static const char *prevtrack[]  =   { "mpc", "prev", NULL };
static const char *playpause[]  =   { "mpc", "toggle", NULL };
static const char *editor[]     =   { "$EDITOR", NULL };
static const char *guieditor[]  =   { "gvim", "-f", NULL };
static const char *fmcmd[]      =   { "thunar", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY|ShiftMask,             XK_j,      zoom,           {0} },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY,                       XK_q,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} }, /* tile */
    { MODKEY,                       XK_g,      setlayout,      {.v = &layouts[1]} }, /* grid */
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} }, /* floating */
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[3]} }, /* monocle */
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    { MODKEY|ShiftMask,             XK_o,      spawn,          {.v = browsercmd } },
    { MODKEY|ShiftMask,             XK_f,      spawn,          {.v = fmcmd } },
    { MODKEY,                       XK_v,      spawn,          {.v = guieditor } },
    { MODKEY,                       XK_Print,  spawn,          {.v = windowshot } },
    { 0,                            XK_Print,  spawn,          {.v = screenshot } },
    { 0,                            XK_F10,    spawn,          {.v = prevtrack } },
    { 0,                            XK_F11,    spawn,          {.v = playpause } },
    { 0,                            XK_F12,    spawn,          {.v = nexttrack } },
    { 0,                            XF86XK_AudioRaiseVolume,spawn,          {.v = volup } },
    { 0,                            XF86XK_AudioLowerVolume,spawn,          {.v = voldown } },
    { 0,                            0x1008ff12,spawn,          {.v = volmute } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};


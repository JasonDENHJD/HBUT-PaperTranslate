%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{hbut_translate}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexart}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexart}%
}
\newif\ifhbut@print \hbut@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexart}%
    \hbut@printtrue%
}
%-
%-> Language
%-
\newif\ifhbut@plain \hbut@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexart}%
    \hbut@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifhbut@versioninfo \hbut@versioninfofalse
\DeclareOption{draftversion}{%
    \hbut@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexart}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexart}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\hbutlntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/hbut_translate.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifhbut@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    %\RequirePackage{ulem}% loaded by xeCJKfntef
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-3em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%- special cell
%- \specialcell[<align2>]{align1}{text1\\text2};
%- <align1>: t,c,b; <align2> l,c,r; @{} suppress spaces before and after text 
\newcommand{\specialcell}[3][c]{%
    \begin{tabular}[#2]{@{}#1@{}}#3\end{tabular}}


%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
% 设置中文字体
\setCJKfamilyfont{zs}[AutoFakeBold = {3}]{STZhongsong}


\def\hbut@value@ch@schoollogo{}
\newcommand{\schoollogo}[2]{\def\hbut@value@ch@schoollogo{\includegraphics[#1]{#2}}}

\def\hbut@value@ch@title{}
\renewcommand{\title}[1]{\def\hbut@value@ch@title{#1}}

\def\hbut@value@ch@author{}
\renewcommand{\author}[1]{\def\hbut@value@ch@author{\uline{\makebox[12em]{#1}}}}

\def\hbut@value@ch@authorid{}
\newcommand{\authorid}[1]{\def\hbut@value@ch@authorid{\uline{\makebox[12em]{#1}}}}

\def\hbut@value@ch@faculty{}
\newcommand{\faculty}[1]{\def\hbut@value@ch@faculty{\uline{\makebox[12em]{#1}}}}

\def\hbut@value@ch@class{}
\newcommand{\class}[1]{\def\hbut@value@ch@class{\uline{\makebox[12em]{#1}}}}

\def\hbut@value@ch@advisor{}
\newcommand{\advisor}[1]{\def\hbut@value@ch@advisor{\uline{\makebox[12em]{#1}}}}

\renewcommand{\maketitle}{
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \CJKfamily{zs}
        
        \vspace*{2em}

        {\linespread{1.0}\zihao{-0}\hbut@value@ch@schoollogo}

        \vspace*{2em}

        {\zihao{1}\bfseries \hbut@label@ch@thesis}

        \vspace*{3em}

        \begin{flushleft}
            \linespread{1.0}
            \zihao{-3}
            \hbut@label@ch@title
            \setlength{\parindent}{8em}
            \hbut@value@ch@title
        \end{flushleft}
        
        \vspace*{6em}

        {\linespread{2.4}
        \zihao{3}
        \hbut@label@ch@author   \hspace{0.5em}  \hbut@value@ch@author\\
        \hbut@label@ch@authorid \hspace{0.5em}  \hbut@value@ch@authorid\\
        \hbut@label@ch@faculty  \hspace{0.5em}  \hbut@value@ch@faculty\\
        \hbut@label@ch@class    \hspace{0.5em}  \hbut@value@ch@class\\
        \hbut@label@ch@advisor  \hspace{0.5em}  \hbut@value@ch@advisor\\
        }

        \vspace*{5em}
        
        {\linespread{1}\zihao{4}\heiti \hbut@value@ch@date}

    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifhbut@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifhbut@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifhbut@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi

}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifhbut@plain%
    \def\contentsname{\hbut@label@en@tocname}
    \def\listfigurename{\hbut@label@en@lsfigname}
    \def\listtablename{\hbut@label@en@lstabname}
    \def\bibname{\hbut@label@en@bibname}
    \def\refname{\hbut@label@en@bibname}
    \def\algname{\hbut@label@en@algname}
    \def\bibetal{\hbut@label@en@bibetal}
    \def\biband{\hbut@label@en@biband}
    \def\axiomname{\hbut@label@en@axiomname}
    \def\theoremname{\hbut@label@en@theoremname}
    \def\lemmaname{\hbut@label@en@lemmaname}
    \def\corollaryname{\hbut@label@en@corollaryname}
    \def\assertionname{\hbut@label@en@assertionname}
    \def\propositionname{\hbut@label@en@propositionname}
    \def\conjecturename{\hbut@label@en@conjecturename}
    \def\definitionname{\hbut@label@en@definitionname}
    \def\examplename{\hbut@label@en@examplename}
    \def\remarkname{\hbut@label@en@remarkname}
    \def\proofname{\hbut@label@en@proofname}
    \def\@author{\hbut@value@en@author}
\else
    \def\contentsname{\hbut@label@ch@tocname}
    \def\listfigurename{\hbut@label@ch@lsfigname}
    \def\listtablename{\hbut@label@ch@lstabname}
    \def\algname{\hbut@label@ch@algname}
    \def\bibname{\hbut@label@ch@bibname}
    \def\refname{\hbut@label@ch@bibname}
    \def\bibetal{\hbut@label@ch@bibetal}
    \def\biband{\hbut@label@ch@biband}
    \def\axiomname{\hbut@label@ch@axiomname}
    \def\theoremname{\hbut@label@ch@theoremname}
    \def\lemmaname{\hbut@label@ch@lemmaname}
    \def\corollaryname{\hbut@label@ch@corollaryname}
    \def\assertionname{\hbut@label@ch@assertionname}
    \def\propositionname{\hbut@label@ch@propositionname}
    \def\conjecturename{\hbut@label@ch@conjecturename}
    \def\definitionname{\hbut@label@ch@definitionname}
    \def\examplename{\hbut@label@ch@examplename}
    \def\remarkname{\hbut@label@ch@remarkname}
    \def\proofname{\hbut@label@ch@proofname}
    \def\@author{\hbut@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure elements configuration
%---------------------------------------------------------------------------%
%- section
\ctexset {
    section = {
        format = \noindent\centering\linespread{1.6}\zihao{-2},
        number = {},
        aftername = {},
        beforeskip = {0pt},
        afterskip = {0pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.6}\zihao{-3},
        number = \arabic{subsection},
        numberformat = {\rmfamily},
        aftername = \quad,
        beforeskip = {0pt},
        afterskip = {0pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.6}\zihao{4},
        number = \arabic{subsection}.\arabic{subsubsection},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {0pt},
        afterskip = {0pt},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@sectionvspace{1ex}% vertical space between section titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from article.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty\@secpenalty
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \if@compatibility
                \global\@nobreaktrue
                \everypar{\global\@nobreakfalse\everypar{}}%
            \fi
        \endgroup
    \fi
}
%- redefine l@section from article.cls to add dotted toc line
\renewcommand*\l@section[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\z@
        \addpenalty\@secpenalty
        \addvspace{\@sectionvspace \@plus\p@}%
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
        \endgroup
    \fi
}
%- redefine indentation for others
%\renewcommand*\l@section{\@dottedtocline{1}{0em}{1em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{1em}{1.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{2em}{2.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{3em}{3.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{4em}{4.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{0.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{0em}{0.8em}}
%---------------------------------------------------------------------------%
\endinput
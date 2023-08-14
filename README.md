% Options for packages loaded elsewhere
\PassOptionsToPackage{unicode}{hyperref}
\PassOptionsToPackage{hyphens}{url}
%
\documentclass[
]{book}
\usepackage{amsmath,amssymb}
\usepackage{iftex}
\ifPDFTeX
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{textcomp} % provide euro and other symbols
\else % if luatex or xetex
  \usepackage{unicode-math} % this also loads fontspec
  \defaultfontfeatures{Scale=MatchLowercase}
  \defaultfontfeatures[\rmfamily]{Ligatures=TeX,Scale=1}
\fi
\usepackage{lmodern}
\ifPDFTeX\else
  % xetex/luatex font selection
\fi
% Use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
\IfFileExists{microtype.sty}{% use microtype if available
  \usepackage[]{microtype}
  \UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
\makeatletter
\@ifundefined{KOMAClassName}{% if non-KOMA class
  \IfFileExists{parskip.sty}{%
    \usepackage{parskip}
  }{% else
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{6pt plus 2pt minus 1pt}}
}{% if KOMA class
  \KOMAoptions{parskip=half}}
\makeatother
\usepackage{xcolor}
\usepackage{graphicx}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\makeatother
% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
% Set default figure placement to htbp
\makeatletter
\def\fps@figure{htbp}
\makeatother
\setlength{\emergencystretch}{3em} % prevent overfull lines
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
\setcounter{secnumdepth}{-\maxdimen} % remove section numbering
\ifLuaTeX
  \usepackage{selnolig}  % disable illegal ligatures
\fi
\IfFileExists{bookmark.sty}{\usepackage{bookmark}}{\usepackage{hyperref}}
\IfFileExists{xurl.sty}{\usepackage{xurl}}{} % add URL line breaks if available
\urlstyle{same}
\hypersetup{
  hidelinks,
  pdfcreator={LaTeX via pandoc}}

\author{}
\date{}

\begin{document}
\frontmatter

\mainmatter
The goal of this project is to become more familiar with \href{https://www.terraform.io/}{Terraform} and HCL native syntax. Modules provided in this repository will replicate the infrastructure in use.

This repository only contains materials used or produced while learning and should never be used in any production environment.

\hypertarget{nlueckenhoff.github.io}{%
\section{\texorpdfstring{\href{https://nlueckenhoff.github.io}{nlueckenhoff.github.io}}{nlueckenhoff.github.io}}\label{nlueckenhoff.github.io}}

\begin{figure}
\centering
\includegraphics{./wiki-topology.jpg}
\caption{alt text}
\end{figure}

\hypertarget{aws-cf-static-overview}{%
\section{aws-cf-static overview}\label{aws-cf-static-overview}}

A scheduled \href{https://github.com/features/actions}{GitHub Actions} runner puts the index.html object to an S3 access point for a bucket in Primary Region. The object is copied to another S3 bucket in Failover Region via cross-region replication. Separate buckets in both regions receive S3 server access logs.

A CloudFront distribution is configured with an origin group containing the main S3 bucket from each region. The bucket in Primary Region operates as the primary origin for the distribution while the bucket in Failover Region acts as a failover origin.

Appropriate IAM policies are generated with least privilege necessary and attached. Bucket policies are generated to enforce secure transport and block public access. SNS topics and CloudWatch alarms are not included in the module but can be created separately to track desired metrics such as the number of requests to the CloudFront distribution over a defined time period.

The result is a CloudFront distribution that delivers the static site with high availability. Each S3 bucket blocks all public access and HTTPS requests are served/enforced. The main advantage of this approach is a reduction in cost of data out of S3 (free to CloudFront), TLS enforcement (S3 website endpoints do not support HTTPS), and the protections provided by AWS Shield standard.

\backmatter
\end{document}

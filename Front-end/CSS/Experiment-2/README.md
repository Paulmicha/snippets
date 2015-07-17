
Unstable CSS organization experiment (WIP)
==========================================
Iteration 2


## Tools
- [Gulp](http://gulpjs.com/)
- [cssnext](http://cssnext.io/)


## Installation
```
npm install
```


## Usage
```
cd /path/to/project/css

#   Watch (default Gulp task)
gulp

#   Single, manual compilation
#   @todo
#gulp build
```


## Structure
```
path/to/project/
    └── css/
        ├── base/           <- 1
        │   └── ...
        ├── generic/        <- 2
        │   └── ...
        ├── specific/       <- 3
        │   └── ...
        ├── node_modules/   <- (gitignored deps)
        │   └── ...
        ├── index.css       <- Input (compilation entry point)
        ├── main.css        <- Output (compiled result)
        └── critical.css    <- 4
```
### 1. `base/` : Bare HTML tags & global declarations
Each file contains a category from [Josh Duck’s HTML Periodic Table](http://smm.zoomquiet.io/data/20110511083224/index.html) ([Screenshot](http://bradfrost.com/wp-content/uploads/2012/11/Screen-Shot-2012-11-13-at-5.15.05-PM.png)).  
Exception : headings are in their own separate file, as their typographic nature could be considered beetween text-level semantics and sectionning (hierarchy).  
Additions :  
- @necolas's [Normalize](https://github.com/necolas/normalize.css/)
- @mrmrs_'s Bascss [base-reset](https://github.com/basscss/base-reset)
- @mrmrs_'s [tachyons-box-sizing](https://github.com/mrmrs/tachyons-box-sizing)
- Bits and pieces to adapt from @paulrobertlloyd's [Barebones](https://github.com/paulrobertlloyd/barebones)

Note : some base styles are specific (default tags appearance / low potential for reuse).  
@bradfrost's terminology : **Atoms**

### 2. `generic/` : Immutable Objects & Utilities
These styles should have a decent potential for reuse.  
Examples :  
- SUIT CSS [components-flex-embed](https://github.com/suitcss/components-flex-embed)
- @mrmrs_'s [colors](https://github.com/mrmrs/colors)
- etc.

@bradfrost's terminology : usually **Molecules**, maybe even **Organisms**

### 3. `specific/` : Current Project Styles
Low potential for reuse, but these styles shouldn't necessarily be unstructured either.  
Within that folder, the organization should accomodate the size of the current project, and/or personal preference - ex : transposing @HugoGiraudel's [Architecture for a Sass Project](http://www.sitepoint.com/architecture-sass-project/)  
Examples :  
- Variables overrides (media queries values, objects and utilities customizations, etc.)
- Variations, extensions of objects ("specialization" of generic styles)
- *Theme* modifiers (as in @csswizardry's namespace terminology)
- Custom components

@bradfrost's terminology : should mostly relate to **Organisms**, **Templates** and **Pages**, but could also include lower-level styles like **Molecules**.

### 4. `critical.css`
This file is the result of a separate compilation, taking any CSS file ending with `.critical.css` (double extension), and optionally (TODO : compilation options) folders like `base/` or `generic/` (as the main layout and typography are usually abstracted - like grids, widths, box-model measures or scales).  
Alternative tool to generate this file : @filamentgroup's [criticalCSS](https://github.com/filamentgroup/criticalCSS)
More info :
- @adactio's [Inlining critical CSS for first-time visits](https://adactio.com/journal/8504)
- @filamentgroup's [How we make RWD sites load fast as heck](https://www.filamentgroup.com/lab/performance-rwd.html)
- @chriscoyier's [Authoring Critical Above-the-Fold CSS](https://css-tricks.com/authoring-critical-fold-css/)


## Conventions
• @csswizardry's [Namespaces](http://csswizardry.com/2015/03/more-transparent-ui-code-with-namespaces/)  
• Additional namespaces (custom class prefixes) :  
    · `fx-` : effects or interactions  
    · `b-` : immutable box-model utilities : borders  
    · `m-` : immutable box-model utilities : margins  
    · `p-` : immutable box-model utilities : paddings  
• Double extension `.critical.css` for separate inline "critical" CSS compilation  
• Formatting / coding style :  
    · Use [BEM-like Naming](http://cssguidelin.es/#bem-like-naming)  
    · Tolerate [SUIT CSS naming convention](https://github.com/suitcss/suit/blob/master/doc/naming-conventions.md)  
    · [Meaningful Whitespace](http://cssguidelin.es/#meaningful-whitespace)  
• Components :  
    · Additional namespace by vendor for portability (e.g. `fx-paulmicha-foobar`) ?  


## Guidelines
• [CSS Selectors](http://cssguidelin.es/#css-selectors)  
• [Specificity](http://cssguidelin.es/#specificity)  
• [Architectural Principles](http://cssguidelin.es/#architectural-principles)  


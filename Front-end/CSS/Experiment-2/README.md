
Unstable CSS organization experiment (WIP)
==========================================
Iteration 2


## Tools
- [Gulp](http://gulpjs.com/)
- [cssnext](http://cssnext.io/)


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
→ TODO **decision 1** : split from normalize & other "root" declarations (ex: box-sizing) ?  
@bradfrost's terminology : **Atoms**

### 2. `generic/` : Immutable Objects & Utilities
No components.  
Note : *component* here refers to @csswizardry's namespace terminology (see Conventions section below).  
Examples :  
- SUIT CSS [components-flex-embed](https://github.com/suitcss/components-flex-embed)
- @mrmrs_'s [colors](https://github.com/mrmrs/colors)
- etc.  
@bradfrost's terminology : **Molecules**, maybe even **Organisms**

### 3. `specific/` : Current Project Styles
(Low potential for reuse.)
Media queries values & other variables overrides, *theme* modifiers - @csswizardry's namespace terminology, etc.  
@bradfrost's terminology : **Templates** and **Pages**

### 4. `critical.css`
TODO  
Probably will require many `generic/` styles, as the main layout and typography are usually abstracted - like grids, widths, box-model measures or scales).  
See [Authoring Critical Above-the-Fold CSS](https://css-tricks.com/authoring-critical-fold-css/)  
and [Inlining critical CSS for first-time visits](https://adactio.com/journal/8504)  


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


## Conventions
• @csswizardry's [Namespaces](http://csswizardry.com/2015/03/more-transparent-ui-code-with-namespaces/)  
• Additional namespaces (custom class prefixes) :  
    · `fx-` : effects or interactions  
    · `b-` : immutable box-model utilities : borders  
    · `m-` : immutable box-model utilities : margins  
    · `p-` : immutable box-model utilities : paddings  
• TODO **decision 2** : formatting / coding style : BEM or SUIT (or both, e.g. in separate releases / branches) ?  
• TODO **decision 3** : additional namespace by vendor for portability (e.g. `fx-paulmicha-foobar`) ?  
• TODO **decision 4** : Double extension `.critical.css` for separate inline "critical" CSS compilation  


## Guidelines
• [CSS Selectors](http://cssguidelin.es/#css-selectors)  
• [Specificity](http://cssguidelin.es/#specificity)  
• [Architectural Principles](http://cssguidelin.es/#architectural-principles)  



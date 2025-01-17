---
layout: single
date: Last Modified
title: Macros
permalink: /mathlive/guides/macros/
read_time: false
sidebar:
    - nav: "universal"
toc: true
head:
  stylesheets:
    - https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.11/codemirror.min.css
  scripts:
    - https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.11/codemirror.min.js
    - https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.11/mode/javascript/javascript.min.js
    - https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.11/mode/xml/xml.min.js
  modules:
    - /assets/js/code-playground.min.js
    - //unpkg.com/mathlive?module
---

MathLive has over [800 LaTeX commands](/mathlive/reference/commands/) 
predefined. Some are primitives but others are macros, that is commands defined 
with a LaTeX expression. You can extend MathLive with your own macros.{.xl}


## Adding/Removing Macros

**To add a macro** use `mf.macros = {...mf.macros, ...}`.

If you do not include the `...mf.macros` call, all the standard macros will be
turned off.

The example below will define a new command, `\average`, which will be
replaced by `\operatorname{average}`, that is displayed as a single unit
using an upright font.

Try changing `\operatorname` to `\mathbf` to see the difference.

<code-playground layout="stack" show-line-numbers mark-javascript-line="3">
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
mf.macros = { ...mf.macros,
  average: '\\operatorname{average}',
};</pre>
    <pre slot="html">&lt;math-field id="mf"&gt;\average([2, 4, 8])}&lt;/math-field&gt;</pre>
</code-playground>

<hr>

You can use standard LaTeX commands in the definition of a macro. For example,
the following macro definition uses the `\,` and `\;` commands to insert
horizontal spacing and `{}^` to place the `\prime` command on the subscript
line.

```javascript
mf.macros = { ...mf.macros,
  minutes: "\\,{}^\\prime\\;",
  seconds: "\\,\\doubleprime\\;",
};
```

<hr>

The macro definition can contain up to eight arguments, represented by `#1` to `#9`.

<code-playground layout="stack" show-line-numbers >
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
mf.macros = {...mf.macros, 
  smallfrac: '{}^{#1}\\!\\!/\\!{}_{#2}',
};
</pre>
    <pre slot="html">&lt;math-field id="mf"&gt;\smallfrac{5}{7}+\frac{5}{7}&lt;/math-field&gt;</pre>
</code-playground>

<hr>

By default, a macro command behaves as a group whose subcomponents cannot be
modified. This behavior can be controlled using the `captureSelection` flag
in the expanded definition of a macro.

**To define a macro whose content is selectable and editable** set 
`captureSelection` to `false`.

<code-playground layout="stack" show-line-numbers mark-javascript-line=6>
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
mf.macros = {...mf.macros,
  smallfrac: {
    args: 2,
    def: '{}^{#1}\\!\\!/\\!{}_{#2}',
    captureSelection: false,
  },
};
</pre>
    <pre slot="html">&lt;math-field id="mf"&gt;\scriptCapitalE=\smallfrac{5}{7}+\frac{5}{7}&lt;/math-field&gt;</pre>
</code-playground>

<hr>

**To remove a macro** set its definition to undefined:

<code-playground layout="stack" show-line-numbers>
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
mf.macros = {...mf.macros, diamonds: undefined };</pre>
    <pre slot="html">&lt;math-field id="mf"&gt;\diamonds&lt;/math-field&gt;</pre>
</code-playground>


## Adding a Matching Shortcut

By defining a new macro, a new LaTeX command is added to the dictionary
of commands that can be used in a LaTeX expression. 

To input a macro, type <kbd>\\</kbd> followed by the macro name, then <kbd>RETURN</kbd>

Custom macros are also included in the value of the mathfield 
expressed as a LaTeX string (`mf.value`).

It may also be convenient to associate the macro with an inline
shortcut. Inline shortcuts can be typed without having to enter the LaTeX
editing mode (without having to type the <kbd>\\</kbd> key).

**To define an associated inline shortcut**, use the `inlineShortcuts` option.

<code-playground layout="stack" show-line-numbers>
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
//
mf.macros = {...mf.macros,
  // This means that the command macro `\minutes`
  // will be replaced with `\,{}^\\prime\\;`
  minutes: '\\,{}^\\prime\\;',
  seconds: '\\,\\doubleprime\\;',
};
//
mf.inlineShortcuts = {...mf.inlineShortcuts,
  // This means that typing the inline shortcut 
  // "minutes" will insert the command "\minutes"
  minutes: '\\minutes', 
  seconds: '\\seconds',
};
</pre>
    <pre slot="html">&lt;math-field id="mf"&gt;
  3\minutes 15\seconds
&lt;/math-field&gt;</pre>
</code-playground>


{% readmore "/mathlive/guides/shortcuts/" %}
**Next:** Manage <strong>Key bindings and Inline Shortcuts</strong>
{% endreadmore %}



## Inspecting Available Macros

**To view the available macros**, inspect the `macros` property:

<code-playground layout="stack" show-line-numbers>
    <style slot="style">
      .output:focus-within {
        outline: Highlight auto 1px;
        outline: -webkit-focus-ring-color auto 1px
      }
      .output math-field:focus, .output math-field:focus-within {
        outline: none;
      }
    </style>
    <pre slot="javascript">const mf = document.getElementById('mf');
console.log(mf.macros);
</pre>
    <pre slot="html">&lt;math-field id='mf'&gt;x=\frac{-b\pm \sqrt{b^2-4ac}}{2a}&lt;/math-field&gt;</pre>
</code-playground>


## Disabling Macros

**To turn off all macros**, use  `mf.macros = {}`.




{% readmore "/mathlive/guides/shortcuts/" %}
**Next:** Manage <strong>Key Bindings and Inline Shortcuts</strong>
{% endreadmore %}

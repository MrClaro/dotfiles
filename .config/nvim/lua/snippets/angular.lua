local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- ngModel
  s("ngM", {
    t('[(ngModel)]="'),
    i(1, "variavel"),
    t('"'),
  }),

  -- @for Block (Angular 17+)
  s("@for", {
    t("@for ("),
    i(1, "item of items; track $index"),
    t(") {"),
    t({ "", "  " }),
    i(0),
    t({ "", "}" }),
  }),

  -- @if Block (Angular 17+)
  s("@if", {
    t("@if ("),
    i(1, "condicao"),
    t(") {"),
    t({ "", "  " }),
    i(0),
    t({ "", "}" }),
  }),

  -- @else Block
  s("@else", {
    t("@else {"),
    t({ "", "  " }),
    i(0),
    t({ "", "}" }),
  }),

  -- *ngIf
  s("*ngif", {
    t('*ngIf="'),
    i(1, "condicao"),
    t('"'),
  }),

  -- *ngFor
  s("*ngfor", {
    t('*ngFor="let '),
    i(1, "item"),
    t(" of "),
    i(2, "items"),
    t('; trackBy: trackByFn"'),
  }),

  -- ngClass
  s("ngclass", {
    t('[ngClass]="{ '),
    i(1, "classe: condicao"),
    t(' }"'),
  }),

  -- ngStyle
  s("ngstyle", {
    t('[ngStyle]="{ '),
    i(1, "'propriedade': valor"),
    t(' }"'),
  }),

  -- Click event
  s("click", {
    t('(click)="'),
    i(1, "metodo()"),
    t('"'),
  }),

  -- Submit event
  s("submit", {
    t('(ngSubmit)="'),
    i(1, "metodo()"),
    t('"'),
  }),

  -- FormGroup
  s("formgroup", {
    t('[formGroup]="'),
    i(1, "meuForm"),
    t('"'),
  }),

  -- FormControl
  s("formcontrol", {
    t('formControlName="'),
    i(1, "nomeControle"),
    t('"'),
  }),

  -- Pipe
  s("pipe", {
    t("{{ "),
    i(1, "valor"),
    t(" | "),
    i(2, "pipe"),
    t(" }}"),
  }),

  -- Interpolation
  s("interpol", {
    t("{{ "),
    i(1, "valor"),
    t(" }}"),
  }),

  -- Angular component
  s("component", {
    t("<"),
    i(1, "app-component"),
    t(" ["),
    i(2, "propriedade"),
    t(']="'),
    i(3, "valor"),
    t('"></'),
    t("app-component"),
    t(">"),
  }),

  -- Input property
  s("input", {
    t("["),
    i(1, "propriedade"),
    t(']="'),
    i(2, "valor"),
    t('"'),
  }),

  -- Output event
  s("output", {
    t("("),
    i(1, "evento"),
    t(')="'),
    i(2, "handler($event)"),
    t('"'),
  }),
}

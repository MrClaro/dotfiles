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

  -- @for Block
  s("@for", {
    t("@for ("),
    i(1, "item of items; track $index"),
    t(") {"),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- @if Block
  s("@if", {
    t("@if ("),
    i(1, "condicao"),
    t(") {"),
    t({ "", "\t" }),
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
    t('; track $index"'),
  }),

  -- ngclass
  s("ngclass", {
    t('[ngClass]="{ '),
    i(1, "classe: condicao"),
    t(' }"'),
  }),

  -- ngstyle
  s("ngstyle", {
    t('[ngStyle]="{ '),
    i(1, "propriedade: valor"),
    t(' }"'),
  }),

  -- click
  s("click", {
    t('(click)="'),
    i(1, "metodo()"),
    t('"'),
  }),

  -- submit
  s("submit", {
    t('(ngSubmit)="'),
    i(1, "metodo()"),
    t('"'),
  }),

  -- formgroup
  s("formgroup", {
    t('[formGroup]="'),
    i(1, "meuForm"),
    t('"'),
  }),

  -- formcontrol
  s("formcontrol", {
    t('[formControl]="'),
    i(1, "meuControle"),
    t('"'),
  }),

  -- pipe
  s("pipe", {
    t("{{ "),
    i(1, "valor"),
    t(" | "),
    i(2, "pipe"),
    t(" }}"),
  }),

  -- interpol
  s("interpol", {
    t("{{ "),
    i(1, "valor"),
    t(" }}"),
  }),
}

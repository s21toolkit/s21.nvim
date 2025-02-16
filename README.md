# Фичи

- База
  - Открыть склоненный проект на гитлабе
  - Автоматически открывать markdown preview при открытии проекта
  - Автоматически переключатся/создавать deveop ветку
- SQL Bootcamp
  - Автоматический менеджмент postgres
  - Шорткаты для переключения между упражнениями
  - Запуск тестов если test.sql лежит в папке с упражнением
  - Выполнение sql из буффера по шорткату

# Внешние зависимости

- Встроенный markdown preview
  - [firefox](https://www.mozilla.org/en-US/firefox/)
  - [vivify-sever](https://github.com/jannis-baum/Vivify)
  - [i3-msg](https://i3wm.org/)
  - [jq](https://jqlang.org/)
- SQL Bootcamp
  - [docker compose](https://docs.docker.com/compose/)
  - [psql](https://www.postgresql.org/docs/current/app-psql.html)

# Установка

<details open>
<summary>Lazy</summary>

```lua
return {
  's21toolkit/s21.nvim',
  event = 'VeryLazy', -- Грузим сразу если cond удовлетворяет что бы превью сразу открывалось
  cond = function() return vim.fn.getcwd():match('/s21/') ~= nil end,
  dependencies = {
    -- Нужен для менеджмента докером и дефолтным превью таски
    -- 'stevearc/overseer.nvim',
    -- Нужен для встроенного поведения sql.format а конкретно sql-formatter из его репозитория
    -- 'williamboman/mason.nvim',
  },
  keys = {
    { '<leader>;', '<cmd>S21GitlabOpen<cr>', mode = { 'n', }, },
  },
  opts = {
    switch = true, -- Автоматически переключатся на develop или создавать его если ещё нету такой ветки
    task = {
      -- Управляет дефолтным поведением (оно опираеться на overseer, jq, firefox, i3, viv по этому false по дефолту)
      -- preview = false,
      -- Можно и с более подробными настройками
      -- preview = {
      --    fargs = '--new-window', -- Дополнительные аргументы для браузера
      --    width = 1400, -- Ширина окна браузера в пикселях
      --    delay = 0.5, -- Задержка перед открытием превью после запуска браузера
      -- },
      -- Или же определить кастомный опенер прямо тут
      preview = function ()
        local api = require('s21.api')
        if not api.i3.window_title_contains(api:project_dir_name()) then
          -- https://github.com/jannis-baum/Vivify
          vim.system({ 'sh', '-c', 'viv ' .. vim.fs.joinpath(api:project_root(), 'README*.md') })
        end
      end
    },
    sql = {
      -- Угадывать ли количество упражнений в дне создавая структуру ex0X/day0Y_ex0X.sql
      init = true,
      -- Настройки контейнера постгреса
      postgres = {
        password = 'somepassword',
        user = 'someuser',
        db = 'school21'
        port = 5432,
      },
      keymap = {
        -- Все exec требуют установленный psql cli
        -- проверки на его наличие нету как и встроенной установки
        -- так что готовьтесь к ошибкам если его нету в PATH
        psqlexec = '<leader>p', -- выполняет sql из текущего буффера
        testexec = '<leader>\'', -- запускает тест если есть
        nextexec = '\'', -- переходит к следующему упражнению выполняя его и прогоняя тесты если есть
        prevex = ',', -- предыдущее упражнение
        nextex = '.', -- следующее упражнение
      }
    },
  },
}
```
</details>

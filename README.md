# SimpleVoting — контракт голосования на Solidity

Учебный проект: смарт-контракт для голосования по одному вопросу.

## Что делает
- Создатель задаёт от 2 до 20 вариантов ответа при деплое.
- Любой адрес может проголосовать **один раз** за любой вариант.
- Создатель может закрыть голосование функцией `closeVoting()`.
- После закрытия доступна функция `getWinner()`, которая возвращает победителя.

## Технологии
- Solidity ^0.8.20
- Протестировано в Remix IDE и тестовой сети Sepolia

## Как запустить (Remix IDE)

1. Открыть [remix.ethereum.org](https://remix.ethereum.org).
2. Создать новый файл `SimpleVoting.sol`, вставить код из `contracts/SimpleVoting.sol`.
3. Вкладка **Solidity Compiler** → выбрать версию `0.8.20` → **Compile**.
4. Вкладка **Deploy & Run** → Environment: `Remix VM (Cancun)`.
5. В поле рядом с кнопкой **Deploy** ввести варианты, например:
   `["Python", "JavaScript", "Go"]` (с кавычками, как JSON-массив).
6. Нажать **Deploy**.
7. В разделе **Deployed Contracts** вызывать функции:
   - `vote(0)` — проголосовать за Python;
   - `getResults()` — посмотреть текущие результаты;
   - `closeVoting()` — закрыть (только из аккаунта создателя);
   - `getWinner()` — узнать победителя.

## Что демонстрирует
- `mapping` для отслеживания проголосовавших
- `modifier onlyOwner` / `whenOpen`
- события `Voted` и `VotingStatusChanged`
- `view`-функции и `immutable`-переменная

## Лицензия
MIT

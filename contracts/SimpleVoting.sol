// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleVoting — контракт голосования по одному вопросу
/// @notice Создатель задаёт варианты ответа, любой адрес может проголосовать один раз.
///         Создатель может закрыть голосование, после чего можно узнать победителя.
/// @dev Учебный проект. Демонстрирует: массивы, mapping, modifiers, events, view-функции.
contract SimpleVoting {
    // ==================== СОСТОЯНИЕ ====================

    /// @notice Адрес создателя контракта (того, кто его задеплоил)
    address public immutable owner;

    /// @notice Массив вариантов ответа. public => авто-геттер options(uint256)
    string[] public options;

    /// @notice Массив счётчиков голосов, индекс совпадает с options
    uint256[] public votes;

    /// @notice Кто уже голосовал — защита от двойного голоса
    mapping(address => bool) public hasVoted;

    /// @notice Открыто ли голосование
    bool public votingOpen;

    // ==================== СОБЫТИЯ ====================

    /// @notice Эмитится при каждом голосе
    event Voted(address indexed voter, uint256 optionIndex);

    /// @notice Эмитится при смене статуса голосования
    event VotingStatusChanged(bool isOpen);

    // ==================== МОДИФИКАТОРЫ ====================

    /// @dev Разрешает вызов только создателю контракта
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /// @dev Разрешает вызов только пока голосование открыто
    modifier whenOpen() {
        require(votingOpen, "voting closed");
        _;
    }

    // ==================== КОНСТРУКТОР ====================

    /// @param _options список вариантов ответа (минимум 2, максимум 20)
    constructor(string[] memory _options) {
        require(_options.length >= 2, "need at least 2 options");
        require(_options.length <= 20, "too many options");

        owner = msg.sender;
        options = _options;
        votes = new uint256[](_options.length); // массив нулей нужной длины
        votingOpen = true;

        emit VotingStatusChanged(true);
    }

    // ==================== ОСНОВНЫЕ ФУНКЦИИ ====================

    /// @notice Проголосовать за вариант по его индексу (0, 1, 2...)
    /// @dev whenOpen — проверяет, что голосование открыто
    function vote(uint256 optionIndex) external whenOpen {
        require(!hasVoted[msg.sender], "already voted");
        require(optionIndex < options.length, "invalid option");

        // Checks-effects-interactions: сначала меняем состояние
        hasVoted[msg.sender] = true;
        votes[optionIndex] += 1;

        emit Voted(msg.sender, optionIndex);
    }

    /// @notice Закрыть голосование. Только создатель.
    function closeVoting() external onlyOwner {
        require(votingOpen, "already closed");
        votingOpen = false;

        emit VotingStatusChanged(false);
    }

    // ==================== VIEW-ФУНКЦИИ (бесплатные) ====================

    /// @notice Вернуть все варианты и все счётчики голосов
    function getResults() external view returns (string[] memory, uint256[] memory) {
        return (options, votes);
    }

    /// @notice Сколько всего вариантов (для циклов в UI)
    function getOptionsCount() external view returns (uint256) {
        return options.length;
    }

    /// @notice Определить победителя. Можно вызывать только после закрытия.
    /// @return winnerOption название варианта-победителя
    /// @return winnerVotes сколько за него голосов
    function getWinner() external view returns (string memory winnerOption, uint256 winnerVotes) {
        require(!votingOpen, "voting still open");

        uint256 maxVotes = 0;
        uint256 winnerIdx = 0;

        for (uint256 i = 0; i < votes.length; i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
                winnerIdx = i;
            }
        }

        return (options[winnerIdx], maxVotes);
    }
}

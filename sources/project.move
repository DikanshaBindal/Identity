module MyModule::AutomatedSavings {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to store the user's savings percentage.
    struct SavingsConfig has store, key {
        percentage: u64,  // Savings percentage (e.g., 10 for 10%)
        balance: u64,     // Total saved amount
    }

    /// Function to initialize the savings percentage for a user.
    public fun initialize_savings(account: &signer, percentage: u64) {
        assert!(percentage <= 100, 1); // Ensure percentage is valid
        move_to(account, SavingsConfig { percentage, balance: 0 });
    }

    /// Function to deposit income and save the specified percentage automatically.
    public fun deposit_income(account: &signer, amount: u64) acquires SavingsConfig {
        let config = borrow_global_mut<SavingsConfig>(signer::address_of(account));
        let savings_amount = (amount * config.percentage) / 100;

        // Transfer the savings amount to savings balance
        let deposit = coin::withdraw<AptosCoin>(account, savings_amount);
        coin::deposit<AptosCoin>(signer::address_of(account), deposit);

        config.balance = config.balance + savings_amount;
    }
}

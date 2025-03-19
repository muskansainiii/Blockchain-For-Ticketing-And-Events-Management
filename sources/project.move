module TicketingSystem::EventManager {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Event has store, key {
        ticket_price: u64, // Price of one ticket
        total_sold: u64,   // Number of tickets sold
    }

    public fun create_event(organizer: &signer, ticket_price: u64) {
        let event = Event {
            ticket_price,
            total_sold: 0,
        };
        move_to(organizer, event);
    }

    public fun buy_ticket(buyer: &signer, organizer: address) acquires Event {
        let event = borrow_global_mut<Event>(organizer);
        let payment = coin::withdraw<AptosCoin>(buyer, event.ticket_price);
        coin::deposit<AptosCoin>(organizer, payment);
        event.total_sold = event.total_sold + 1;
    }
}

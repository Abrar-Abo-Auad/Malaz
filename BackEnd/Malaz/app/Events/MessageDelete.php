<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;

class MessageDelete implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets;

    public $payload;

    public function __construct(array $payload)
    {
        $this->payload = $payload;
    }

    public function broadcastOn()
    {
        return new PrivateChannel('conversations.' . $this->payload['conversation_id']);
    }

    public function broadcastAs()
    {
        return 'MessageDeleted';
    }

    public function broadcastWith()
    {
        return $this->payload;
    }
}
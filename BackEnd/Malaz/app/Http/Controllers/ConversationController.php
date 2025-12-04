<?php

namespace App\Http\Controllers;

use App\Models\Conversation;
use App\Http\Requests\StoreConversationRequest;
use App\Http\Requests\UpdateConversationRequest;
use App\Models\Property;

class ConversationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = auth()->user();
        $conversations = Conversation::where('user_one_id', $user->id)
            ->orWhere('user_two_id', $user->id)
            ->with(['property', 'userOne', 'userTwo'])
            ->latest()
            ->get();

        return response()->json([
            'conversations' => $conversations,
            'status' => 200,
        ]);
    }
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreConversationRequest $request)
    {
        $user = auth()->user();
        $property = Property::find($request->property_id);
        if (!$property) {
            return response()->json(['error' => 'Property not found'], 404);
        }

        if ($property->owner_id === $user->id) {
            return response()->json(['error' => 'You cannot start a conversation with yourself'], 400);
        }

        $ids = [$user->id, $property->owner_id];
        sort($ids);

        $conversation = Conversation::firstOrCreate([
            'user_one_id' => $ids[0],
            'user_two_id' => $ids[1],
            'property_id' => $request->property_id,
        ]);

        return response()->json([
            'message' => $conversation->wasRecentlyCreated
                ? 'Conversation created successfully'
                : 'Conversation already exists',
            'conversation' => $conversation,
            'status' => $conversation->wasRecentlyCreated ? 201 : 200,
        ]);

    }

    /**
     * Display the specified resource.
     */
    public function show(Conversation $conversation)
    {
        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $messages = $conversation->messages()->with('sender')->latest()->take(20)->get();
        return response()->json([
            'message' => 'here are your conversation',
            'conversation' => $conversation,
            'last_messages' => $messages,
            'status' => 200,
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Conversation $conversation)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateConversationRequest $request, Conversation $conversation)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Conversation $conversation)
    {
        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $conversation->delete();
        return response()->json([
            'message' => 'deleted complete',
            'status' => 200,
        ]);
    }
}

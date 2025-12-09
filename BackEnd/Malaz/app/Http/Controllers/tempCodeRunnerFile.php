<?php
$message->delete();
            $deleted = Message::withTrashed()->find($message->id);
            broadcast(new MessageDelete($deleted))->toOthers();
            return response()->json([
                'message' => 'message deleted successfully',
            ], 200);
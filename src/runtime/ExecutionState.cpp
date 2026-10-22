/*
 * Copyright (c) 2022-present Samsung Electronics Co., Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Walrus.h"
#include "runtime/ExecutionState.h"

#if defined(__linux__)
#include <pthread.h>
#endif

namespace Walrus {
thread_local ExecutionState* ExecutionState::s_ownedFrames;

void ExecutionState::clampStackLimitToCurrentThreadStack()
{
#if defined(__linux__)
    // A thread's stack range never changes, and pthread_getattr_np() parses
    // /proc/self/maps for the initial thread, so resolve it once per thread.
    static thread_local bool s_resolved;
    static thread_local size_t s_bound;
    if (!s_resolved) {
        s_resolved = true;
        pthread_attr_t attr;
        if (pthread_getattr_np(pthread_self(), &attr) == 0) {
            void* stackAddr = nullptr;
            size_t stackSize = 0;
            if (pthread_attr_getstack(&attr, &stackAddr, &stackSize) == 0 && stackAddr && stackSize) {
                size_t margin = STACK_LIMIT_FROM_END;
                if (margin > stackSize / 2) {
                    margin = stackSize / 2;
                }
#ifdef STACK_GROWS_DOWN
                s_bound = reinterpret_cast<size_t>(stackAddr) + margin;
#else
                s_bound = reinterpret_cast<size_t>(stackAddr) + stackSize - margin;
#endif
            }
            pthread_attr_destroy(&attr);
        }
    }
    if (!s_bound) {
        return;
    }
#ifdef STACK_GROWS_DOWN
    if (m_stackLimit < s_bound) {
        m_stackLimit = s_bound;
    }
#else
    if (m_stackLimit > s_bound) {
        m_stackLimit = s_bound;
    }
#endif
#endif
}
} // namespace Walrus

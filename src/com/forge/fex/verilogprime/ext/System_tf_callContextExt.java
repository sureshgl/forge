package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.System_tf_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class System_tf_callContextExt extends AbstractBaseExt {

	public System_tf_callContextExt(System_tf_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public System_tf_callContext getContext() {
		return (System_tf_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).system_tf_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof System_tf_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ System_tf_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Task_prototypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Task_prototypeContextExt extends AbstractBaseExt {

	public Task_prototypeContextExt(Task_prototypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Task_prototypeContext getContext() {
		return (Task_prototypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).task_prototype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Task_prototypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Task_prototypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
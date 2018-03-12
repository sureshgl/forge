package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TaskstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TaskstrContextExt extends AbstractBaseExt {

	public TaskstrContextExt(TaskstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TaskstrContext getContext() {
		return (TaskstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).taskstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TaskstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TaskstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
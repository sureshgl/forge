package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Task_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Task_identifierContextExt extends AbstractBaseExt {

	public Task_identifierContextExt(Task_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Task_identifierContext getContext() {
		return (Task_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).task_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Task_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Task_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
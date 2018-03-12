package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Task_body_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Task_body_declarationContextExt extends AbstractBaseExt {

	public Task_body_declarationContextExt(Task_body_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Task_body_declarationContext getContext() {
		return (Task_body_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).task_body_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Task_body_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Task_body_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}